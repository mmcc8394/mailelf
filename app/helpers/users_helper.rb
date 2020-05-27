module UsersHelper
  def action_link(path, octicon_name, aria_label)
    link_to(path, class: 'm-3', title: aria_label) do
      octicon(octicon_name, height: 20, 'aria-label': aria_label)
    end
  end

  def action_link_delete(path)
    link_to(path, method: :delete, class: 'm-3', title: 'delete', data: { confirm: 'Are you sure you want to delete this?' }) do
      octicon('trashcan', height: 20, 'aria-label': 'delete')
    end
  end
end
