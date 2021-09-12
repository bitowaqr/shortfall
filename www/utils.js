

document.addEventListener('DOMContentLoaded', (event) => {

    // fade out intor page
    function removeFadeOut( el, speed ) {
        var seconds = speed/1000;
        el.style.transition = "opacity "+seconds+"s ease";

        el.style.opacity = 0;
        setTimeout(function() {
            el.parentNode.removeChild(el);
        }, speed);
    }

    // fade in main
    function showFadeIn( el, speed ) {
        var seconds = speed/1000;
        el.style.transition = "opacity "+seconds+"s ease";
        el.style.opacity = 1;
    }

    // speedy way to remove intor page: just press enter
    window.addEventListener('keydown', function(e){
        if (e.keyCode == 13) {
            document.querySelector("#close_intro").click()
        }
      });

    // remove intro and show main when start is clicked
    document.querySelector("#close_intro").addEventListener("click", () => {
        removeFadeOut(document.querySelector('#intro_page'), 500);
        // main_l = document.querySelector('#main-left');
        // main_r = document.querySelector('#main-right');
        // main_l.style.display = "block";
        // main_r.style.display = "block";
        // showFadeIn(main_l, 500)
        // showFadeIn(main_r, 500)
    });

      // send email when contact is clicked
      document.querySelector("#contact").addEventListener("click", () => {
        window.location = "mailto:p.schneider@sheffield.ac.uk";
      });
      
      
      // link to github source code
      document.querySelector("#code").addEventListener("click", () => {
        window.open('https://github.com/bitowaqr/shortfall', '_blank')
      });


  })
