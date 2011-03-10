Todos = SC.Application .create()



Todos.Todo = SC.Object .extend
  title:  null
  isDone: false



Todos.todoListController = SC.ArrayController .create
    content: []


    createTodo: (title) -> 
        todo = Todos.Todo .create title:title 
        @pushObject todo


    remaining: ( -> 
        @filterProperty('isDone', false) .get 'length'
    ) .property('@each.isDone')


    clearCompletedTodos: -> 
        @filterProperty('isDone', true) .forEach(@removeObject, @)


    allAreDone: ((key, value) -> 
        if (value isnt undefined) 
            @setEach('isDone', value)
            value
        else 
            @get('length') and @everyProperty('isDone', true)
    ) .property('@each.isDone')



Todos.CreateTodoView = SC.TemplateView .create SC.TextFieldSupport, 
    insertNewline: -> 
        if value = @get 'value'
            Todos.todoListController .createTodo value
            @set 'value', ''



Todos.clearCompletedView = SC.TemplateView .create
    mouseUp: -> 
        Todos.todoListController .clearCompletedTodos()



Todos.todoListView = SC.TemplateCollectionView .create
    contentBinding: 'Todos.todoListController'

    itemView: SC.TemplateView .extend
        isDoneDidChange: ( -> 
            isDone = @getPath 'content.isDone'
            @$() .toggleClass 'done', isDone
        ) .observes('.content.isDone')



Todos.CheckboxView = SC.TemplateView .extend SC.CheckboxSupport, 
    valueBinding: '.parentView.content.isDone'



Todos.statsView = SC.TemplateView .create 
    remainingBinding: 'Todos.todoListController.remaining'

    displayRemaining: ( -> 
        remaining = @get 'remaining'

        remaining + (if remaining is 1 then " item" else " items")
    ) .property('remaining') .cacheable()




Todos.markAllDoneView = SC.TemplateView .create SC.CheckboxSupport,
    valueBinding: 'Todos.todoListController.allAreDone'



jQuery(document) .ready ->
    Todos.mainPane = SC.TemplatePane .append
        layerId:      'todos'
        templateName: 'todos'




















