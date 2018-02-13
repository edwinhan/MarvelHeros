    
1. About the MarvelHeros app

MarvelHeros is an iPhone application which used Marvel APIs for displaying characters. It's written in swift and no thrid party libs were used. It's implemented following the MVVM design pattern, aiming to provide better separations of concerns, reducing size of view controllers and making the code more testable and maintainable .

2. Structure of the app:

---MarvelHeros

    ---Classes
            ---General
            ---Modules
                ---MarvelHeroList
                    ---Controller
                    ---View
                    ---Model
                    ---ViewModel
            ---OtherModules...
            ---APIs

The difference with MVC pattern is that MVVM introduced a view model layer which will expose the right data and commands objects that view needs. In this demo, the main business logic fetching data from marvel APIs are implemented in ViewModel, and viewModel composition is more prefered than inheritance. Each one viewModel with handle one business case. Extracting of the logics in standalone viewModel make the app more testable without the UI.

And for the APIs part, I used to use AFNetworking framework. But this time, I wrote a very simple BaseApi class to handle things related to restful reuqests, and allow sub API class to config http method type and http parmeters quickly and simply.



3. Known issues:
    1) The app may have some UI issues on old version of iOS, but not a big block for the demo
    2) A task not finished yet is to write a json wrapper convert JSON to model object easily, but may be we can use some third party libs.

