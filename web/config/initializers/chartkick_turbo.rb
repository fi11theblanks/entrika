Rails.application.config.to_prepare do
  module ChartkickTurboScript
    def chartkick_chart(klass, data_source, **options)
      output = super
      if output.respond_to?(:sub)
        output = output.sub("<script", '<script data-turbo-eval="always"')
      end
      output.respond_to?(:html_safe) ? output.html_safe : output
    end
  end

  Chartkick::Helper.prepend(ChartkickTurboScript)
end
