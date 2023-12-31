#include "Object.as"
#define CLIENT_ONLY
Tool tool = Tool(); 
Telescope scope = Telescope(); 

void onInit(CBlob@ this)
{
	//if(!this.isMyPlayer()) return;
	Render::addScript(Render::layer_prehud, "RenderHUDstuff.as", "hud", 2.0f);
	//print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
	if(tool !is null)
		tool = Tool();
}

class Telescope
{
	Vertex[] v_raw;
	u16[] v_i;
	
	Telescope(){}
	
	Telescope()
	{
		Vec2f ScS = Vec2f(getDriver().getScreenWidth(), getDriver().getScreenHeight());

		Vertex[] _v_raw = {
			Vertex(0,0,0,0,0,									SColor(255, 0, 0, 0)),
			Vertex(getScreenWidth(),0,0,1,0,					SColor(255, 0, 0, 0)),
			Vertex(getScreenWidth(),getScreenHeight(),0,1,1,	SColor(255, 0, 0, 0)),
			Vertex(0,getScreenHeight(),0,0,1,					SColor(255, 0, 0, 0))
		};
		Render::SetTransformScreenspace();

		u16[] _v_i = {
			0,1,2,
			0,2,3
		};

		this.v_raw = _v_raw;
		this.v_i = _v_i;
	}	

    void DrawScope()
    {    	
        Render::RawTrianglesIndexed("LookingGlass.png", this.v_raw, this.v_i);
    }
};

class Tool
{
	Vertex[] cursor_raw;
	Vertex[] v_raw;
	u16[] v_i;
	
	Tool(){}
	
	Tool()
	{
		Vec2f ScS = Vec2f(getDriver().getScreenWidth(), getDriver().getScreenHeight());

		Vertex[] _cursor_raw = 
		{
			Vertex( (ScS.x/2)-26,  (ScS.y/2)+26,   0,   0.0,  0.75, color_white),
			Vertex( (ScS.x/2)+26,  (ScS.y/2)+26,   0,   1.0,  0.75, color_white),
			Vertex( (ScS.x/2)+26,  (ScS.y/2)-26,   0,   1.0,  1.0, color_white),
			Vertex( (ScS.x/2)-26,  (ScS.y/2)-26,   0,   0.0,  1.0, color_white)
		};
		Vertex[] _v_raw = 
		{
			Vertex((ScS.x/1.35-(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128), ScS.y/2, 0,  0, 		  0),
			Vertex((ScS.x/1.35+(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128), ScS.y/2, 0,  1.000f/3, 0),
			Vertex((ScS.x/1.35+(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128), ScS.y,   0,  1.000f/3, 1.000f/5),
			Vertex((ScS.x/1.35-(ScS.y-ScS.y/2)/2+(ScS.y-ScS.y/2)/128), ScS.y,   0,  0, 		  1.000f/5)
		};
		u16[] _v_i = {
			0,1,2,
			0,2,3
		};

		this.cursor_raw = _cursor_raw;
		this.v_raw = _v_raw;
		this.v_i = _v_i;
	}	

    void DrawTool(int team, bool drawcursor)
    {    	
       // Render::RawTrianglesIndexed("Tools.png", this.v_raw, this.v_i);

        if (drawcursor) 
        Render::RawTrianglesIndexed("Cursors.png", this.cursor_raw, this.v_i); 
    }
	
	void SetFrame(int _index)
	{
		v_raw[0].u = v_raw[3].u = 1.000f/3*_index;
		v_raw[1].u = v_raw[2].u = 1.000f/3*_index+1.000f/3;
	}

	void SetType(int _row)
	{
		v_raw[0].v = v_raw[1].v = 1.000f/5*_row;
		v_raw[2].v = v_raw[3].v = 1.000f/5*_row+1.000f/5;
	}
};

void hud(int id)
{
	CPlayer@ p = getLocalPlayer();
	if(p !is null)
	{
		CBlob@ b = p.getBlob();
		if(b !is null)
		{
			Render::SetTransformScreenspace();

			string currentTool = b.get_string( "current tool" );	

	    	if (currentTool == "telescope" )
	    	{
	    		if ( (b.getSprite().getFrame() - 22) == 2)  
		    	{
		    		scope.DrawScope();		    		
		    	} 
	    		else
	    		{
	    			tool.DrawTool(b.getTeamNum(), false);
	    		}
	    		 
	    	}
	    	else
	    	{
	        	tool.DrawTool(b.getTeamNum(), true);	        	
	    	}
		}
	}
}

int index = 0;
int row = 0;

void onTick(CBlob@ this)
{
	if(!this.isMyPlayer()) return;

	if (this.getSprite().isAnimation("shoot") || this.getSprite().isAnimation("punch") || 
		this.getSprite().isAnimation("reclaim") || this.getSprite().isAnimation("repair") || 
		this.getSprite().isAnimation("scopein") || this.getSprite().isAnimation("scopeout"))
	{
		tool.SetFrame(this.getSprite().getFrame() - 22);
	}

	string currentTool = this.get_string( "current tool" );

	if (currentTool == "pistol")
	{
    	tool.SetType(0);
	}
	else if (currentTool == "fists")
	{
    	tool.SetType(1);
	}
	else if (currentTool == "reconstructor")
	{
    	tool.SetType(2);
	}	
	else if (currentTool == "deconstructor")
	{
    	tool.SetType(3);
	}
	else if (currentTool == "telescope")
	{
    	tool.SetType(4);

    	if ((this.getSprite().getFrame() - 22) > 0)  
    	{
    		f32 FOV = this.get_f32("FOV");
    		if (FOV > 3.0)
    		{
    			FOV -= 2.5f;
    		}
    		this.set_f32("FOV", FOV);		    		
    	} 
		else
		{
			f32 FOV = this.get_f32("FOV");
    		if (FOV < 10.5)
    		{
    			FOV += 2.5f;
    		}
    		this.set_f32("FOV", FOV);	
		}
	}
}