require 'rails'

module CodePoetry
  class Railtie < Rails::Railtie
    railtie_name :code_poetry

    rake_tasks do
      load "tasks/code_poetry.rake"
    end
  end
end
