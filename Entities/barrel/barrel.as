void onInit(CBlob@ this)
{
	CShape@ shape = this.getShape();
	shape.SetGravityScale(0.0f);
	shape.SetRotationsAllowed(false);
	this.set_u8("ID", 3);
	this.Tag("prop");
}

