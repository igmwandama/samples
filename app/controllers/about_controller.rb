class AboutController < ApplicationController
    def about
        @title = "MobileBank App"
        @theme = "This project emulates a mobile banking system , though not all essential features are developed as of now (Its a working progress) <strong><span class=\"text-info\">
                    #wink!</span></strong>.<br /><br />"
        @description = "This project is developed to demonstrate programming skills in Ruby On Rails.</br> Primarily designed as a 
                        RESTFull API to be consumed in an Android app (which is not developed yet).
                        With the initial design some of the links might take you to json output. <br />
                        <br>
                        <strong>Please not that some features are to be implemented</strong><br />
                        <ul id=\"horizontal\">
                            <li><i class=\"glyphicon glyphicon-play-circle\"></i> Error Handling,</li>
                            <li><i class=\"glyphicon glyphicon-play-circle\"></i> Messages</li>
                            <li><i class=\"glyphicon glyphicon-play-circle\"></i> Database Exceptions</li>
                        </ul>"
    end
end