class Task
  attr_reader :status, :description, :status, :tags
  def initialize(arguments)
    @status = arguments[0].downcase.to_sym
    @description = arguments[1]
    @priority = arguments[2].downcase.to_sym
    @tags = (arguments[3] or "").split(', ')
  end
  def self.parse_line line
    task_attrs = line.split('|').map do |attr|
      attr.strip
    end
    Task.new *task_attrs
  end
end
class Criteria
  attr_accessor :proc

  def initialize(proc)
    @proc = proc
  end

  class << self
    def status(target_status)
      new { |task| task.status == target_status }
    end

    def priority(target_priority)
      new { |task| task.priority == target_priority }
    end

    def tags(target_tags)
      new { |task| (target_tags - task.tags).empty? }
    end
  end

  def !
    Criteria.new { |task| not @proc.call(task) }
  end

  def &(other)
    Criteria.new { |task| @proc.call(task) and other.proc.call(task) }
  end

  def |(other)
    Criteria.new { |task| @proc.call(task) or other.proc.call(task) }
  end
end

class TodoList
  include Enumarable
  attr_accessor :task_list

  def initialize(list)
    @task_list = list
  end

  def each
    @task_list.each{ |task| yield task }
  end

  def self.parse(text)
    tasks = text.each_line.map do |line|
      Task.parse_line line
    end
    TodoList.new tasks
  end

  def filter(criteria)
    TodoList.new select(&criteria)
  end

  def adjoin(other)
    TodoList.new to_a | other.to_a
  end

  def tasks_todo
    count(&Criteria.status(:todo))
  end

  def tasks_in_progress
    count(&Criteria.status(:current))
  end

  def tasks_completed
    count(&Criteria.status(:done))
  end

  def completed?
    all?(&Criteria.status(:done))
  end
end