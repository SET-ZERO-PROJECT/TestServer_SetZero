$(document).ready(function() {
    window.addEventListener('message', function(event) {
        var data = event.data;
        var health = event.data.health;
        var armor = event.data.armor;
        var food = event.data.food;
        var water = event.data.water;
        var shower = event.data.shower;
        var bed = event.data.bed;
        var shower = event.data.shower;
        var stress = event.data.stress;
        var stamina = event.data.stamina;
        var id = event.data.id;
        var dive = event.data.dive;

        $("#h").css("width", health + "%");
        $("#a").css("height", armor + "%");
        $("#fo").css("height", food + "%");
        $("#wa").css("height", water + "%");

        $("#sa").css("width", shower + "%");
        $("#ba").css("width", bed + "%");
        $("#ss").css("height", stress + "%");
        $("#sm").css("width", stamina + "%");

        $("#id").html(Math.round(id));
        $("#h-p").html(Math.round(health) + "%");
        $("#a-p").html(Math.round(armor) + "%");
        $("#f-p").html(Math.round(food) + "%");
        $("#w-p").html(Math.round(water) + "%");
        $("#s-p").html(Math.round(stress) + "%");
        $("#sm-p").html(Math.round(stamina) + "%");


        if (data.dive >= 100) {
            $("#swim-box").css("display", "none");
        } else if (data.dive <= 70) {
            $("#swim-box").css("display", "flex");
        }

    })
})

