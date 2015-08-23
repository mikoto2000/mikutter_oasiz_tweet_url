# -*- coding: utf-8 -*-

Plugin.create(:oasiz_tweet_url) do

    # ツイート URL をクリップボードにコピー
    command(:oasiz_tweet_url_copy,
        name: 'Copy tweet URL',
        condition: Plugin::Command[:HasMessage],
        visible: true,
        role: :timeline) do |opt|
            urls = []
            for message in opt.messages
                screen_name = message.user[:idname]

                urls.push(build_tweet_url(screen_name, message.id))
            end
            Gtk::Clipboard.copy(urls.join(", "))
    end

    # ツイート URL を開く
    command(:oasiz_tweet_url_open,
        name: 'Open tweet URL',
        condition: Plugin::Command[:HasMessage],
        visible: true,
        role: :timeline) do |opt|
            for message in opt.messages
                screen_name = message.user[:idname]

                Gtk::openurl(build_tweet_url(screen_name, message.id))
            end
    end

    # プロフィール URL をクリップボードにコピー
    command(:oasiz_profiel_url_copy,
        name: 'Copy profile URL',
        condition: Plugin::Command[:HasMessage],
        visible: true,
        role: :timeline) do |opt|
            urls = []
            for message in opt.messages
                screen_name = message.user[:idname]

                urls.push(build_profile_url(screen_name))
            end

            urls.uniq!
            Gtk::Clipboard.copy(urls.join(", "))
    end

    # プロフィール URL を開く
    command(:oasiz_profiel_url_open,
        name: 'Open profile URL',
        condition: Plugin::Command[:HasMessage],
        visible: true,
        role: :timeline) do |opt|
            urls = []
            for message in opt.messages
                screen_name = message.user[:idname]

                urls.push(build_profile_url(screen_name))
            end

            urls.uniq!

            for url in urls
                Gtk::openurl(url)
            end
    end

    def build_tweet_url(screen_name, id)
        "https://twitter.com/#{screen_name}/status/#{id}"
    end

    def build_profile_url(screen_name)
        "https://twitter.com/#{screen_name}"
    end
end
