module TagsHelper
  def link_to_tag(tag_name, tag_id, type)
    kaller = self.respond_to?(:link_to) ? self : view_context
    kaller.link_to tag_name, issues_path(utf8: "✓", set_filter: '1', f: ["status_id", type.to_s], op: {"status_id"=>"o", type.to_s => "="}, v: {type.to_s => [tag_id]}, project_id: @project.try(:identifier)), class: 'tag'
  end

  def wrap_tag_into_html(tag, issue_id, type)
    philter = "#{type.to_s}_tag_id"
    issues_link = link_to_tag(tag[:name], tag[:id], philter)
    destroy_link = send("destroy_#{type.to_s}_tagging_path", {issue_id: issue_id, tag_id: tag[:id]})
    build_html_for_tag(issues_link, destroy_link)
  end

  def build_html_for_tag(issues_link, destroy_link)
    %{<span class="tag-container">#{issues_link}<span class="tag-del" data-url="#{destroy_link}">✕</span></span>}
  end

  def last_update data
    data.select('MAX(updated_at) as last_update').first.try(:last_update)
  end
end
