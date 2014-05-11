class ChurnCalculator
  def initialize(repo_path)
    @repo_path = repo_path
  end

  def calculate(stat)
    result_string = get_churns(stat.file)
    stat.set_churns(parse(result_string))
  end

  private

  def get_churns(file)
    `cd #{@repo_path} && git log --all --name-only --format='format:' #{file} | grep -v '^$' | uniq -c`
  end

  def parse(string)
    count, _ = string.split(' ')
    count.to_i
  end
end
