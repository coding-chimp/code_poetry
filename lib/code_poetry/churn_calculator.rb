class ChurnCalculator
  def initialize(path)
    @repo_path = find_directory(path)
  end

  def calculate
    parse_log_for_churns
  end

  private

  def find_directory(path)
    if File.file?(path)
      File.dirname(path)
    else
      path
    end
  end

  def parse_log_for_churns
    churns = {}

    logs.each do |line|
      churns[line] ? churns[line] += 1 : churns[line] = 1
    end

    churns
  end

  def logs
    `cd #{@repo_path} && \
      git log --all --name-only --format='format:' | grep -v '^$'`.split("\n")
  end

  def sort_churns
    @churns.sort! {|first,second| second[1] <=> first[1]}
  end
end
