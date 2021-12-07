# landing page

landingDiv = function(){
  
  
  HTML('
    <div class="landing mx-auto px-sm-2 px-3 py-1 mb-3 d-flex flex-column ">
         <div class="intro-text intro-title display-1 mx-auto">
                      QALY SHORTFALL CALCULATOR
                    </div>
                    <div class="intro-text fs-2 intro-subtitle mx-auto my-5">
                        Paul Schneider, Simon McNamara, James Love-Koh, Tim Doran, Nils Gutacker
                    </div>
                    <div class = "logos d-flex flex-row justify-content-center flex-wrap mx-auto px-5">
                        <div class="cell">
                            <img  class ="image" src="sheffield_logo.png">
                        </div>
                        <div class="cell">
                            <img class ="image" src="york_logo.png">
                        </div>
                        <div class="cell">
                            <img class ="image" src="bresmed_logo_copy.png">
                        </div>
                    </div>
                    <div class="progress">
                      <div class="progress-bar" role="progressbar" style="width: 0%" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100"></div>
                    </div>

         </div>')
  
}