void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	this.set_u8("ID", 2);
	this.Tag("prop");
}

