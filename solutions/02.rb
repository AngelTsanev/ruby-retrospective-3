class Task
  def self.parse(line)
    status, description, priority, tags = line.split('|').map(&:strip)
    tags = tags.nil? ? [] : tags.split(', ')

    Task.new status, description, priority, tags
  end

  attr_accessor :status, :description, :priority, :tags

  def initialize(status, description, priority, tags)
    @status      = status.downcase.to_sym
    @description = description
    @priority    = priority.downcase.to_sym
    @tags        = tags
  end
end

module TodoListStatistics
  def tasks_todo
    @task_list.select { |task| task.status == :todo } .size
  end

  def tasks_in_progress
    @task_list.select { |task| task.status == :current } .size
  end

  def tasks_completed
    @task_list.select { |task| task.status == :done } .size
  end

  def completed?
    @task_list.all? { |task| task.status == :done }
  end
end

class TodoList
  def self.parse(input)
    lines = input.split("\n")
    TodoList.new lines.map { |line| Task.parse(line) }
  end

  include Enumerable
  include TodoListStatistics
  attr_accessor :task_list

  def initialize(tasks)
    @task_list = tasks
  end

  def each
    @task_list.each{ |task| yield task }
  end

  def filter(criteria)
    TodoList.new @task_list.select { |task| criteria.matches.(task) }
  end

  def adjoin(other)
    TodoList.new (@task_list + other.task_list).uniq
  end
end

class Criteria
  class << self
    def status(status)
      Criteria.new -> (task) { task.status == status }
    end

    def priority(priority)
      Criteria.new -> (task) { task.priority == priority }
    end

    def tags(tags)
      Criteria.new -> (task) { (task.tags & tags).length == tags.length }
    end
  end

  attr_reader :matches

  def initialize(matches)
    @matches = matches
  end

  def &(other)
    Criteria.new -> (task) do
      matches.(task) && other.matches.(task)
    end
  end

  def |(other)
    Criteria.new -> (task) do
      matches.(task) || other.matches.(task)
    end
  end

  def !
    Criteria.new -> (task) { not matches.(task) }
  end
end