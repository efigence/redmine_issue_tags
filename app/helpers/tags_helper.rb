module TagsHelper
  def link_to_tag(tag_name, tag_id, type, count=nil)
    display = count ? "#{tag_name} [#{count}]" : tag_name
    kaller = self.respond_to?(:link_to) ? self : view_context
    kaller.link_to display, issues_path(utf8: "✓", set_filter: '1', f: ["status_id", type.to_s, ""], op: {"status_id"=>"o", type.to_s => "="}, v: {type.to_s => [tag_id]}, c: ["status", "tracker", "priority", "subject", "assigned_to", "updated_on"], group_by: "", project_id: @project.try(:identifier)), class: 'tag'
  end
end
