class Object
{
	string texture;
	Vertex[] v_raw;
	u16[] v_i;
	bool billboard;
	bool team_switch;
	
	Object(){}
	
	Object(string _texture, Vertex[] _v_raw, u16[] _v_i, bool _billboard)
	{
		this.texture = _texture;
		this.v_raw = _v_raw;
		this.v_i = _v_i;
		this.billboard = _billboard;
		team_switch = false;
	}
	
	Object(string _texture, Vertex[] _v_raw, u16[] _v_i, bool _billboard, bool _team_switch)
	{
		this.texture = _texture;
		this.v_raw = _v_raw;
		this.v_i = _v_i;
		this.billboard = _billboard;
		team_switch = _team_switch;
	}
	
	void Draw(CBlob@ blob)
    {
        if(this.team_switch)
			Render::RawTrianglesIndexed(this.texture+blob.getTeamNum()+".png", this.v_raw, this.v_i);
		else
			Render::RawTrianglesIndexed(this.texture, this.v_raw, this.v_i);
    }
};
