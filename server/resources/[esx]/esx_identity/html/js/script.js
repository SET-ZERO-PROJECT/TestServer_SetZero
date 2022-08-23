

// // var nameValidate = /[^a-z]/g;
// // var onlyTextValifate = /[^a-zA-Z ]/g
// // var onlyNumberValidate =/[^0-9 ]/g



// // function ValidateActInsert() {
// //     var specialChars = /[^a-zA-Z ]/g;
// //     if (document.actorInsert.actInsert.value.match(specialChars)) {
// //         alert ("Only characters A-Z, a-z and 0-9 are allowed!")
// //         document.actorInsert.actInsert.focus();
// //         return false;
// //     }
// //     return (true);
// // }


// function validateName(name) {
//     var val =name.val();

//     if (
//         val
//     )



//     var val = name.val();
//     if (val && val.length > 10 && val.indexOf(" ") > 0) {
//       console.log("valid", val);
//     } else {
//       console.log("invalid", val);
//     }
//   }


// $("#register").submit(function(event) {
//     event.preventDefault(); // Prevent form from submitting
    
//     // Verify date
//     var fname = $("#fname").val();
//     var lname = $("#lname").val();
//     var dob = $("#dob").val();
//     var height = $("#height").val();
//     var dateCheck = new Date($("#dob").val());


//     if (fname && fname.length < 10 && fname.index)

//     // if (dateCheck == "Invalid Date") {
//     //     date == "invalid";
//     // }

//     $.post('http://esx_identity/register', JSON.stringify({
//         firstname: $("#firstname").val(),
//         lastname: $("#lastname").val(),
//         dateofbirth: date,
//         sex: $(".sex:checked").val(),
//         height: $("#height").val()
//     }));
// });


$(function() {
	$.post('http://esx_identity/ready', JSON.stringify({}));

	window.addEventListener('message', function(event) {
		if (event.data.type == "enableui") {
			document.body.style.display = event.data.enable ? "block" : "none";
		}
	});
	
	$("#register").submit(function(event) {
		event.preventDefault(); // Prevent form from submitting
		
		// Verify date
		var date = $("#dateofbirth").val();
		var dateCheck = new Date($("#dateofbirth").val());

		if (dateCheck == "Invalid Date") {
			date == "invalid";
		}
		else {
			const ye = new Intl.DateTimeFormat('en', { year: 'numeric' }).format(dateCheck)
			const mo = new Intl.DateTimeFormat('en', { month: '2-digit' }).format(dateCheck)
			const da = new Intl.DateTimeFormat('en', { day: '2-digit' }).format(dateCheck)
			
			var formattedDate = `${mo}/${da}/${ye}`;

			$.post('http://esx_identity/register', JSON.stringify({
				firstname: $("#fname").val(),
				lastname: $("#lname").val(),
				dateofbirth: formattedDate,
				sex: $("input[type='radio'][name='sex']:checked").val(),
				height: $("#height").val()
			}));
		}
	});
});

