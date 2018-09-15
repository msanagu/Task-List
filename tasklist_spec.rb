require 'rspec'
require_relative 'tasklist'

# ------------------------------STARTING USER STORIES

# PASSED- Story: As a developer, I can create a Task.

describe Task do
    before do
        @myTask = Task.new("test-title", "test-description")
        # @myTaskList = TaskList.new()
    end

    it "I can create a Task." do
        expect{Task.new}.to_not raise_error
    end

# PASSED- Story: As a developer, I can give a Task a title and retrieve it.
# NOTE: Make getter and setter for title and description

    it "I can give a Task a title and retrieve it" do
        expect(@myTask.title).to eq("test-title")
        expect(@myTask.title).to be_a(String)
    end

# PASSED- Story: As a developer, I can give a Task a description and retrieve it.

    it "I can give a Task a description and retrieve it" do
        expect(@myTask.description).to eq("test-description")
        expect(@myTask.description).to be_a(String)
    end

# PASSED_ Story: As a developer, I can mark a Task done.
# Story: As a developer, when I print a Task that is done, its status is shown.

    it "I can mark a Task done" do
        expect(@myTask.complete).to eq(false)
        @myTask.markComplete
        expect(@myTask.complete).to eq(true)
        expect(@myTask.markComplete).to be_a(String)
        expect(@myTask.markComplete).to eq("#{@myTask.title} is complete.")
    end
end

# PASSED
# Story: As a developer, I can add all of my Tasks to a TaskList.
# Hint: A TaskList has-many Tasks

describe TaskList do
    before do
        @myTask = Task.new("test-title", "test-description")
        @myTaskList = TaskList.new()
    end
# PASSED
    it "I can create a TaskList." do
        expect{TaskList.new}.to_not raise_error
    end

    # PASSED
    it "Method in TaskList that adds Task" do
        @myTaskList.addTask(@myTask)
        expect(@myTaskList.master).to eq([@myTask])
    end

# PASSED!
# Story: TaskList will have two arrays for incomplete and complete Tasks
# Both complete and incomplete arrays start off as empty
# Both arrays will have getter/setter
# Both arrays will be updated by the child class

    it "get the completed items" do
        @myTaskList.addTask(@myTask)
        @myTask.markComplete
        expect(@myTaskList.getCompletedItems()).to eq([@myTask])
    end
# PASSED!
    it "get the incompleted items" do
        @myTaskList.addTask(@myTask)
        @myTask.markComplete
        expect(@myTaskList.getIncompleteItems()).to eq([])
    end
end

# ------------------------------EPIC: DUE DATE


# Story: As a developer, I can create a DueDateTask, which is-a Task that has-a due date.
# Hint: Use the built-in Ruby Date class - Date.parse
# NOTE: DueDateTask < Task with a new attribute of dueDate

# PASSED!
describe DueDateTask do
    before do
        @myTaskList = TaskList.new()
        @myDueDateTask = DueDateTask.new("test-title", "test-description", "2018-08-23")
        @myTask = Task.new("incomplete Task", "test-description")
        # @myTaskList = TaskList.new()
    end

    it "I can create a Task." do
        expect{DueDateTask.new}.to_not raise_error
    end

# PASSED!
# Story: As a developer, I can print an item with a due date with labels and values.
# Hint: When implementing to_s, use super to call to_s on the super class.
# NOTE: Child class passes inherited attributes with super but redefines
# all methods to include unique attributes
# TODO: Add to_s in Task and in DueDateTask but use "super" within the DueDateTask class

    it "I can print a DueDateTask with labels and values" do
        expect(@myDueDateTask.to_s).to eq("#{@myDueDateTask.title}-#{@myDueDateTask.description}-#{@myDueDateTask.dueDate}")
    end

# PASSED!
# Story: As a developer, I can add items with due dates to my TaskList.
# Hint: Consider keeping items with due dates separate from the other items.
# TODO: Make a separate master list for DueDateTasks

    it "I can add Due Date Task items to my TaskList" do
        @myTaskList.addTask(@myDueDateTask)
        expect(@myTaskList.dueDateMaster).to be_a(Array)
        expect(@myTaskList.dueDateMaster).to eq([@myDueDateTask])
    end

# PASSED!!
# Story: As a developer with a TaskList, I can list all the not completed items that are due today.
# Add function that checks if dueDateTask is due on today's date

    it "get the DueDateTask items due today" do
        @myTaskList.addTask(@myDueDateTask)
        expect(@myTaskList.dueToday()).to eq([@myDueDateTask])
    end

# PASSED!
# Story: As a developer with a TaskList, I can list all the not completed items in order of due date.
# NOTE: use sort_by DueDate incomplete
    it "I can list all the not completed items in order of due date" do
        @myTaskList.addTask(@myDueDateTask)
        expect(@myTaskList.getIncompleteDueDates()).to eq([@myDueDateTask])
    end

# PASSED!
# Story: As a developer with a TaskList with and without due dates, I can list all the not completed items in order of due date, and then the items without due dates.
# TODO: Use sort_by date for DueDateTasks first and then print out incomplete Tasks by no particular order
    it "I can list all the not completed items in order of due date" do
        @myTaskList.addTask(@myDueDateTask)
        @myTaskList.addTask(@myTask)
        expect(@myTaskList.getIncompleteItems()).to eq([@myDueDateTask, @myTask])
    end
end

# ------------------------------EPIC: ANNIVERSARY

# Epic: Anniversary
# Story: As a developer, I can create a to do item for an anniversary (a yearly recurring event) .
# Hint: An Anniversary has a month and a day.
# Hint: An Anniversary is a special kind of DueDateTask where the due date changes depending on the current date (override the due_date method to return the next annivesary date).

# Anniversary is a child class of DueDateTask that inherits attr dueDate
# Uses Date.today to know when to update dueDate by year++
# Add a method that increments dueDate year by one based on current date

describe AnniversaryTask do
    before do
        @myAnniversaryTask = AnniversaryTask.new("test-title", "test-description", "2018-08-23")
        @myTaskList = TaskList.new()
        @myDueDateTask = DueDateTask.new("test-title", "test-description", "2018-09-23")
        @myTask = Task.new("incomplete Task", "test-description")
    end

    it "I can create an Anniversary Task." do
        expect{AnniversaryTask.new}.to_not raise_error
    end

# PASSED!
# Story: As a developer, I can update the original due date by replacing it with its anniversary date.

    it "I can update the original due date by replacing it with its anniversary date" do
        expect(@myAnniversaryTask.updateDueDate).to eq("2019-08-23")
    end

# PASSED!
# Story: As a developer, I can print an item for an anniversary with field labels and values.

    it "I can print an item for an anniversary with field labels and values" do
        expect(@myAnniversaryTask.to_s).to eq("#{@myAnniversaryTask.title}-#{@myAnniversaryTask.description}-#{@myAnniversaryTask.dueDate}")
    end


# Story: As a developer with a TaskList with and without due dates and yearly recurring dates, I can list all the not completed items in order of due date and yearly dates for the current month.

# TaskList needs a method to sort_by dueDate for incompleted items by month
# add attr :month to dueDateTask
# add method in super class dueDateTask that extracts dueDate month

    it "I can list all the not completed items in order of due date and yearly dates for the current month" do
        @myTaskList.addTask(@myDueDateTask)
        @myTaskList.addTask(@myTask)
        @myTaskList.addTask(@myAnniversaryTask)
        expect(@myTaskList.incompleteMonthTasks()).to eq([@myAnniversaryTask])
    end

# PASSED!
# Story: As a developer with a TaskList with a collection of items with and without due dates and yearly recurring dates, I can list all the not completed items in order of due date and yearly dates for the current month, then the items without due dates.
    it "I can list all the not completed items in order of due date and yearly dates for the current month, then the items without due dates" do
        @myTaskList.addTask(@myDueDateTask)
        @myTaskList.addTask(@myTask)
        @myTaskList.addTask(@myAnniversaryTask)
        expect(@myTaskList.getIncompleteItems()).to eq([@myAnniversaryTask, @myDueDateTask, @myTask])
    end
end
