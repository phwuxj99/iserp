
/// <reference path="jquery-1.4.1-vsdoc.js" />

//$(document).ready(function () {
//    $(".searchinput").autocomplete({
//        source: ["test", "asp.net", "jQuery"],
//        minLength: 2
//    });
//});


$(document).ready(function () {
    $(".searchinput").autocomplete({
        source: function (request, response) {
            $.ajax({
                type: "POST",
                contentType: "application/json; charset=utf-8",
                url: "Services/isErpWebService.asmx/GetAllPredictions",
                data: "{'keywordStartsWith':'" + request.term + "'}",
                dataType: "json",
                async: true,
                success: function (data){
                    response(data.d);
                },
                error: function (result) {
                    alert("Due to unexpected errors we were unable to load data");
                }
                //dataType: "jsonp",
                //data: {
                //    keywordStartsWith: request.term
                //},
//                success: function (data) {
//                    response($.map(data.geonames, function (item) {
//                        return {
//                            label: item.name + (item.adminName1 ? ", " + item.adminName1 : "") + ", " + item.countryName,
//                            value: item.name
//                        }
//                    }));
//                }
            });
        },
        minLength: 2
    });
});