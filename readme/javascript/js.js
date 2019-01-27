$(function(){
  var $section = $(".main").find("section");
  var $link = $(".link");
  var $section_size = $section.length;
  $section.each(function(){
    var $this = $(this);
    $this.css("display", "none");
    var $id = $this.attr("id").split(" ");
    $link.append(`<a href='#${$id[1]}'>${$id[0]}</a>`);
  });
  var $links = $link.find("a");
  $links.on("click", function(){
    var $id2 = $(".link a").index(this);
    $section.each(function(){
      $(this).css("display", "none");
    });
    $($section[$id2]).css("display", "block");
  });

  $($section[0]).css("display", "block")
});