module ApplicationHelper

    # Returns the full title on a per-page basis.
    def full_title(page_title = '')
        base_title = "Tremelo"

        if page_title.empty?
            base_title
        else
            "#{page_title} | #{base_title}" .html_safe
        end
    end

end
