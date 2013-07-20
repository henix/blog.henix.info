#inline Flower.csser
#inline Flower.eventer.addEventListener
#inline Flower.ie.version
#inline Flower.ie.hoverClass
#inline FlowerUI.compiler

function PostItem(elem) {
	this.postLine = null;
	this.postDetail = null;
	this.expanded = null;
}
PostItem.prototype.expand = function() {
	Flower.csser.addClass(this.postLine.parentNode, 'active');
	this.postDetail.style.display = 'block';
	this.expanded = true;
};
PostItem.prototype.collapse = function() {
	this.postDetail.style.display = 'none';
	Flower.csser.removeClass(this.postLine.parentNode, 'active');
	this.expanded = false;
};
PostItem.prototype.toggle = function() {
	if (this.expanded) {
		this.collapse();
	} else {
		this.expand();
	}
};
PostItem.prototype.init = function() {
	var this1 = this;
	this.postDetail.style.display = 'none';
	this.expanded = false;
	Flower.eventer.addEventListener(this.postLine, 'click', function() {
		this1.toggle();
	});
	var ie = Flower.ie.version();
	if (ie && ie < 7) {
		// ie7 以下不支持任意元素的 :hover
		Flower.ie.hoverClass(this.postLine, 'post-line-hover');
	}
};

function CateItem(elem) {
	this.postItems = [];
	this.toggleA = null;
	this.expanded = null;
}
CateItem.prototype.expandAll = function() {
	for (var i = 0; i < this.postItems.length; i++) {
		this.postItems[i].expand();
	}
	this.expanded = true;
	this.toggleA.title = '全部折叠';
};
CateItem.prototype.collapseAll = function() {
	for (var i = 0; i < this.postItems.length; i++) {
		this.postItems[i].collapse();
	}
	this.expanded = false;
	this.toggleA.title = '全部展开';
};
CateItem.prototype.toggleAll = function() {
	if (this.expanded) {
		this.collapseAll();
	} else {
		this.expandAll();
	}
};
CateItem.prototype.init = function() {
	this.expanded = false;
	this.toggleA.title = '全部展开';

	var this1 = this;
	Flower.eventer.addEventListener(this.toggleA, 'click', function() {
		this1.toggleAll();
	});
};
