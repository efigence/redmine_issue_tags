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
          if User.current.allowed_to?(:view_public_tags, project)
            add_available_filter "public_tag_id",
              :type => :list,
              :values => selectable_public_tags
          end
          if User.current.allowed_to?(:manage_private_tags, project)
            add_available_filter "private_tag_id",
              :type => :list,
              :values => selectable_private_tags
          end
        end

        def sql_for_public_tag_id_field(field, operator, v)
          sql_for_tag_field(operator, v, "public_tags")
        end

        def sql_for_private_tag_id_field(field, operator, v)
          sql_for_tag_field(operator, v, "private_tags")
        end

        def sql_for_tag_field(operator, values, context)
          op = case operator
               when '=' then 'IN'
               when '!' then 'NOT IN'
               end

          string_val = values.join(',') # TODO sanitize values

          "tags.id #{op} (#{string_val}) AND taggings.context = '#{context}'"
        end

        private

        def selectable_public_tags
          if project_id.present?
            project = Project.find project_id
            project.public_tags.order(taggings_count: :desc).pluck(:name, :id).map {|a| a.map(&:to_s)}
          else
            # TODO: co wtedy - widzi tagi ze wszystkich projektów...?
          end
        end

        def selectable_private_tags
          if project_id.present?
            project = Project.find project_id
            project.private_tags.order(taggings_count: :desc).pluck(:name, :id).map {|a| a.map(&:to_s)}
          else
            # TODO: widzi wszystkie swoje tagi ze wszystkich projektów
          end
        end

        def joins_for_order_statement_with_tags(order_options)
          joins_string = joins_for_order_statement_without_tags(order_options)

          if joins_string.present?
            joins_string + " " + tags_join_statement
          else
            tags_join_statement
          end
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
          ["INNER JOIN taggings ON taggings.taggable_id = issues.id",
           "INNER JOIN tags ON tags.id = taggings.tag_id"].join(' ')
        end
      end
    end
  end
end
