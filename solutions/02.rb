class Task
  attr_reader :status, :description, :status, :tags
  def initialize(arguments)
    @status = arguments[0].downcase.to_sym
    @description = arguments[1]
    @priority = arguments[2].downcase.to_sym
    @tags = (arguments[3] or "").split(', ')
  end
end
module CriteriaOperations
  def |(other)
    #
  end

  def &(other)
    #
  end

  def !(expresion)
    #
  end
end
class Criteria
  include CriteriaOperations
  attr_accessor :priority, :status, :tags

  def initialize()
    @priority = []
    @status = []
    @tags = []
  end

  def priority(priority_symbol)
    @priority << priority_symbol
  end

  def status(status_symbol)
    @status << status_symbol
  end

  def tags(tags_array)
    @tags << tags_array
  end
end
module TodoListStatistics
  def tasks_todo
    our_task_list.select { |task| task.status == :todo } .size
  end

  def tasks_in_progress
    our_task_list.select { |task| task.status == :current } .size
  end

  def tasks_completed
    our_task_list.select { |task| task.status == :done } .size
  end

  def completed?
    our_task_list.all? { |task| task.status == :done }
  end
end
class TodoList
  include Enumerable
  include TodoListStatistics
  attr_reader :our_task_list

  @our_task_list = []

  def initialize(arguments)
    @our_task_list = arguments
  end
  def self.parse(text)
    task_list = []
    text.split(/\n\t*/).each_with_index do |line|
    task_list << Task.new(line.split(/ *\| */))
    end
    TodoList.new(task_list)
  end
  def each
    @our_task_list.each{ |task| yield task }
  end
end