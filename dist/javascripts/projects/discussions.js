(function(){$(function(){var t,e,n;return n=$("@project-discussion"),n.on("click",function(i){var s;return i.preventDefault(),n.each(function(){return t($(this))}),s=$(this),e(s)}),e=function(e){var n,i;return e.removeClass("rolled"),n=e.find("@project-discussion-comments-counter"),i=e.find("@project-discussion-comments-hide"),n.hide(),i.show(),$("#project-tab-pane").scrollTop(e.position().top),i.on("click",function(n){return n.preventDefault(),n.stopPropagation(),t(e)})},t=function(t){var e,n;return e=t.find("@project-discussion-comments-counter"),n=t.find("@project-discussion-comments-hide"),n.hide(),e.show(),t.addClass("rolled")}})}).call(this);