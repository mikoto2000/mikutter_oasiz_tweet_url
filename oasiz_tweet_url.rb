# -*- coding: utf-8 -*-

Plugin.create(:oasiz_tweet_url) do

    # config に設定項目を追加
    settings("URL") do
        settings("有効設定") do
            boolean 'Copy tweet URL', :oasiz_tweet_url_copy_tweet_enable
            boolean 'Open tweet URL', :oasiz_tweet_url_open_tweet_enable
            boolean 'Copy profile URL', :oasiz_tweet_url_copy_profile_enable
            boolean 'Open profile URL', :oasiz_tweet_url_open_profile_enable
        end
    end

    # デフォルト設定
    on_boot do |service|
        if UserConfig[:oasiz_tweet_url_copy_tweet_enable] == nil
            UserConfig[:oasiz_tweet_url_copy_tweet_enable] = false
        end
        if UserConfig[:oasiz_tweet_url_open_tweet_enable] == nil
            UserConfig[:oasiz_tweet_url_open_tweet_enable] = true
        end
        if UserConfig[:oasiz_tweet_url_copy_profile_enable] == nil
            UserConfig[:oasiz_tweet_url_copy_profile_enable] = false
        end
        if UserConfig[:oasiz_tweet_url_open_profile_enable] == nil
            UserConfig[:oasiz_tweet_url_open_profile_enable] = true
        end
    end

    # ツイート URL をクリップボードにコピー
    command(:oasiz_tweet_url_copy,
        name: 'Copy tweet URL',
        condition: lambda { |opt|
            Plugin::Command[:HasMessage] if UserConfig[:oasiz_tweet_url_copy_tweet_enable]},
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
        condition: lambda { |opt|
            Plugin::Command[:HasMessage] if UserConfig[:oasiz_tweet_url_open_tweet_enable]},
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
        condition: lambda { |opt|
            Plugin::Command[:HasMessage] if UserConfig[:oasiz_tweet_url_copy_profile_enable]},
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
        condition: lambda { |opt|
            Plugin::Command[:HasMessage] if UserConfig[:oasiz_tweet_url_open_profile_enable]},
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
