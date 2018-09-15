require 'date'

class Task
    attr_accessor :title, :description
    attr_reader :complete

    def initialize (title="Untitled", description="No description")
        @title = title
        @description = description
        @complete = false
    end

	# A task can be marked completed
    def markComplete
        @complete = true
        return "#{title} is complete."
    end

	# A task can be given a title and description and they can be retrieved
    def to_s
        "#{@title}-#{@description}"
    end

end

# A subclass of Task is a task with a due date that inherits all super props and methods
class DueDateTask < Task
    attr_accessor :dueDate

    def initialize (title="Untitled", description="No description", dueDate="TBA")
        @dueDate = dueDate
        super(title, description)
    end

    def to_s
        super + "-#{@dueDate}"
    end
end

# A subclass of DueDateTask is a task that reoccurs annually and resets automatically
class AnniversaryTask < DueDateTask
    attr_accessor :dueDate

    def initialize (title="Untitled", description="No description", dueDate="TBA")
        @dueDate = dueDate
        super(title, description, dueDate)
    end

    def updateDueDate
        if Date.today.to_s == @dueDate
            dateArr = @dueDate.split("-")
            newYear = dateArr[0].to_i + 1
            @dueDate = [newYear.to_s, dateArr[1], dateArr[2]].join("-")
        end
    end
end

# A TaskList has many Tasks and those tasks can be retrieved based on their properties
class TaskList
    attr_accessor :master, :dueDateMaster

    def initialize
        @master = []
        @dueDateMaster = []
    end

	# Add task to appropriate master list based on class
    def addTask(task)
        if task.kind_of? DueDateTask
            @dueDateMaster << task
        elsif task.kind_of? AnniversaryTask
            @dueDateMaster << task
        else
            @master << task
        end
    end

	# return all incomplete tasks that are due on the current date
    def dueToday
        dueTodayList = []
        currentDate = Date.today.to_s
        @dueDateMaster.each do |task|
            # if the due date is today AND task is incomplete
            if task.dueDate == currentDate && !task.complete
                dueTodayList << task
            end
        end
        return dueTodayList
    end

	# return all incomplete tasks that are due within the current month
    def incompleteMonthTasks
        incompleteDueDates = []
        # grab current month out of Date.today
        currentDate = Date.today.to_s
        dateArr = currentDate.split("-")
        # store current month within a variable as a string
        currentMonth = dateArr[1]
        # Loop through the existing array of tasks with due dates
        @dueDateMaster.each do |task|
            # Only do this for incomplete tasks with due date
            if !task.complete
                # Pull out the month part of the due date
                taskDateArr = task.dueDate.split("-")
                taskDateMonth = taskDateArr[1]
                # Check if the current month matches the month in task's due date
                if currentMonth == taskDateMonth
                    incompleteDueDates << task
                end
            end
        end
        incompleteDueDates.sort_by! {|task| task.dueDate}
    end

    def getIncompleteDueDates
        @dueDateMaster.sort_by! {|task| task.dueDate}
    end

    def getIncompleteItems
        incompleteDueDates = []
        incompleteTasks = []
        # sort through the dueDateTasks list and only pull out the incomplete ones
        if @dueDateMaster.length > 0
            @dueDateMaster.each do |task|
                if !task.complete
                    incompleteDueDates << task
                end
            end

            incompleteDueDates.sort_by! {|task| task.dueDate}
            incompleteTasks.push(incompleteDueDates).flatten!

        end
        # sort through the incomplete dueDateTask list

        # sort through the Task list and add the incomplete ones to the incompleteTasks array
        @master.each do |task|
            if !task.complete
                incompleteTasks << task
            end
        end

        return incompleteTasks
    end

    def getCompletedItems
        completeTasks = []
        @master.each do |task|
            if task.complete
                completeTasks << task
            end
        end
        return completeTasks
    end
end
