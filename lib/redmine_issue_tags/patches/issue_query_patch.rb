require_dependency 'issue_query'

module RedmineIssueTags
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable
          alias_method_chain :initialize_available_filters, :tags
          alias_method_chain :joins_for_order_statement, :tags
          alias_method_chain :issue_count, :tags
        end
      end
      module InstanceMethods

        def initialize_available_filters_with_tags
          initialize_available_filters_without_tags
          project = Project.find_by(id: project_id)

          if project
            if User.current.allowed_to?(:view_public_tags, project)
              add_available_filter "public_tag_id",
                :type => :list_optional,
                :values => selectable_public_tags(project)
            end
            if User.current.allowed_to?(:manage_private_tags, project)
              add_available_filter "private_tag_id",
                :type => :list_optional,
                :values => selectable_private_tags(project)
            end
          else
            if User.current.allowed_projects_public_tags.any?
              add_available_filter "public_tag_id",
                :type => :list,
                :values => selectable_public_tags
            end

            if User.current.allowed_to_private_tags_globally?
              add_available_filter "private_tag_id",
                :type => :list,
                :values => selectable_private_tags
            end
          end
        end

        def sql_for_public_tag_id_field(field, operator, v)
          sql_for_tag_field(operator, v) do |sql_operator|
            if operator == '!*'
              "(tags.id IS NULL OR tags.id NOT IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'public_tags'))"
            elsif operator == '*'
              "(tags.id IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'public_tags'))"
            else
              "tags.id #{sql_operator} (:ids) AND taggings.context = 'public_tags'"
            end
          end
        end

        def sql_for_private_tag_id_field(field, operator, v)
          sql_for_tag_field(operator, v) do |sql_operator|
            if operator == '!*'
              "(tags.id IS NULL OR tags.id NOT IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'private_tags' AND taggings.tagger_id = #{User.current.id}))"
            elsif operator == '*'
              "(tags.id IN (SELECT DISTINCT tag_id FROM tags INNER JOIN taggings ON tags.id = taggings.tag_id WHERE taggings.context = 'private_tags' AND taggings.tagger_id = #{User.current.id}))"
            else
              "tags.id #{sql_operator} (:ids) AND taggings.context = 'private_tags'"
            end
          end
        end

        private

        def sql_for_tag_field(operator, v, &block)
          tag_ids = v.map(&:to_i)
          sql_operator = sql_operator_for_tags(operator)
          ActiveRecord::Base.send :sanitize_sql_array, [yield(sql_operator), ids: tag_ids]
        end

        def selectable_public_tags(project=nil)
          scope = if project
                    project.public_tags.order(taggings_count: :desc)
                  else
                    User.current.globally_allowed_public_tags
                  end
          scope.pluck(:name, :id).map {|a| a.map(&:to_s)}
        end

        def selectable_private_tags(project=nil)
          scope = if project
                    project.private_tags.order(taggings_count: :desc)
                  else
                    User.current.owned_private_tags
                  end
          scope.pluck(:name, :id).map {|a| a.map(&:to_s)}
        end

        def sql_operator_for_tags(operator)
          case operator
          when '=' then 'IN'
          when '!' then 'NOT IN'
          end
        end

        def joins_for_order_statement_with_tags(order_options)
          joins_string = joins_for_order_statement_without_tags(order_options)
          return joins_string unless tags_query?

          [joins_string, tags_join_statement].reject{|e| e.blank?}.join(' ')
        end

        def issue_count_with_tags
          return issue_count_without_tags unless tags_query?

          Issue.visible.joins(:status, :project).
            joins(tags_join_statement).
            where(statement).count

        rescue ::ActiveRecord::StatementInvalid => e
          raise StatementInvalid.new(e.message)
        end

        def tags_query?
          (filters.keys & %w(public_tag_id private_tag_id)).present?
        end

        def tags_join_statement
          ["LEFT JOIN taggings ON taggings.taggable_id = issues.id",
           "LEFT JOIN tags ON tags.id = taggings.tag_id"].join(' ')
        end
      end
    end
  end
end
