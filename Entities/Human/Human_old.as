#include "HumanCommon.as"
#include "Voxels.as"
//#include "AccurateSoundPlay.as"

void onInit( CBlob@ this )
{
	VoxelMap voxmap;
	this.set("voxmapInfo", @voxmap);	

	this.getShape().SetRotationsAllowed(false);
	this.getShape().SetStatic(true);

	this.Tag("player");	 

	this.set_f32("dir_x", 0.0f);
	this.set_f32("dir_y", 0.0f);

	this.set_f32("pos_x", 24.0f*8);	// world mid
	this.set_f32("pos_y", 23.0f*8); // 1 below sky max
	this.set_f32("pos_z", 24.0f*8); // world mid

	this.addCommandID(camera_sync_cmd);

	this.set_f32("cam rotation", 0.0f);
	this.set_f32("FOV", 10.5f);
	
	this.SetMapEdgeFlags( u8(CBlob::map_collide_up) |
		u8(CBlob::map_collide_down) |
		u8(CBlob::map_collide_sides) );
	
	this.set_u32("menu time", 0);
	this.set_bool( "build menu open", false );
	this.set_string("last buy", "coupling");
	this.set_u32("groundTouch time", 0);
	this.set_bool( "onGround", true );
	this.getShape().getVars().onground = true;
}

void onTick( CBlob@ this )
{
	Move( this );
	
	u32 gameTime = getGameTime();

	if (this.isMyPlayer())
	{
		ManageCamera(this);

		if ( gameTime % 10 == 0 )
		{
			this.set_bool( "onGround", this.isOnGround() );
			this.Sync( "onGround", false );
		}		
	}
}

Vec2f myPos(CBlob@ this)
{
	f32 x = this.get_f32("pos_x");
	f32 z =	this.get_f32("pos_z");
	return Vec2f(x,z);
}

void ManageCamera(CBlob@ this)
{
	//if(this.isMyPlayer() && getNet().isClient())
	//{
		CControls@ c = getControls();
		Driver@ d = getDriver();
		bool ctrl = c.isKeyJustPressed(KEY_LCONTROL);
		if(ctrl){ this.set_bool("stuck", !this.get_bool("stuck")); this.Sync("stuck", true);}
		if(!this.get_bool("stuck") && d !is null && c !is null && !c.isMenuOpened() && !getHUD().hasButtons() && !getHUD().hasMenus())
		{
			Vec2f ScrMid = Vec2f(f32(d.getScreenWidth()) / 2, f32(d.getScreenHeight()) / 2);
			Vec2f dir = (c.getMouseScreenPos() - ScrMid)/10;
			float dirX = this.get_f32("dir_x");
			float dirY = this.get_f32("dir_y");
			dirX += dir.x;
			dirY = Maths::Clamp(dirY-dir.y,-90,90);

			if (dirX > 360)
			dirX = 0;
			else if (dirX < 0)
			dirX = 360;

			this.set_f32("dir_x", dirX);
			this.set_f32("dir_y", dirY);
			c.setMousePosition(ScrMid);

			Vec2f dir2 =  Vec2f((1080.0f/(1+dirY%360)+0.1f)+8.0f,0); // i cant do math dont judge
    		Vec2f aimPos = myPos(this) - dir2.RotateBy(dirX);
	
    		this.set_Vec2f("aim_pos", aimPos);
		}
		if(getGameTime() % 2 == 0)
		{
			SyncCamera(this);
		}
	//}
}

void Move( CBlob@ this )
{
	const bool myPlayer = this.isMyPlayer();
	const f32 camRotation = myPlayer ? getCamera().getRotation() : this.get_f32("cam rotation");
	const bool attached = this.isAttached();
	const bool up = this.isKeyPressed( key_up );
	const bool down = this.isKeyPressed( key_down );
	const bool left = this.isKeyPressed( key_left);
	const bool right = this.isKeyPressed( key_right );	
	const bool action1 = this.isKeyPressed( key_action1 );
	const bool action2 = this.isKeyPressed( key_action2 );		
	const u32 time = getGameTime();
	f32 height = this.get_f32("pos_y");
	string currentTool = this.get_string( "current tool" );

	Vec2f pos = myPos(this); // fake pos
	Vec2f aimpos = this.getAimPos();	

	if (myPlayer)
	{
		this.set_f32("cam rotation", camRotation);
		this.Sync("cam rotation", false);
	}
		

	VoxelMap@ voxmap;
	if (!this.get("voxmapInfo", @voxmap) || voxmap.chunks.length == 0)
	{
		return;
	}		

	if (action1)
	{
		voxmap.SetBlockAt(aimpos.x/8, aimpos.y/8, aimpos.y/8, 3);
	}

	// move
	Vec2f moveVel;		

	int px = (pos.x/8);
	int py = (height/8);
	int pz = (pos.y/8);		

	if (up )  		 { moveVel.y -= Human::walkSpeed; }	
	else if ( down ) { moveVel.y += Human::walkSpeed; }		
	if ( right ) 	 { moveVel.x -= Human::walkSpeed; }
	else if (left )  { moveVel.x += Human::walkSpeed; }	
		
	moveVel.RotateBy( -this.get_f32("dir_x") );	

	bool colleft = (voxmap.GetBlockAtPosition(px-1,py,pz) != 0);
    bool colright = (voxmap.GetBlockAtPosition(px+1,py,pz) != 0);
    bool colforwards = (voxmap.GetBlockAtPosition(px,py,pz-1) != 0);
    bool colbackwards = (voxmap.GetBlockAtPosition(px,py,pz+1) != 0);

    bool falling = (voxmap.GetBlockAtPosition(px,py-1,pz) == 0);
	if (falling && !this.get_bool("stuck"))
	{ height-=1.0; }

    if (colleft)
    moveVel.x = Maths::Min(0,moveVel.x);    
    else if (colright)
    moveVel.x = Maths::Max(0,moveVel.x);
    if (colforwards)
    moveVel.y = Maths::Min(0,moveVel.y);    
    else if (colbackwards)
    moveVel.y = Maths::Max(0,moveVel.y);
  	
	
	this.set_f32("pos_x", pos.x-moveVel.x);
	this.set_f32("pos_z", pos.y-moveVel.y);

	this.set_f32("pos_y", height);
}

bool canSend(CBlob@ this)
{
	return (this.isMyPlayer() || this.getPlayer() is null || this.getPlayer().isBot());
}

void onCommand( CBlob@ this, u8 cmd, CBitStream @params )
{
	if (cmd == this.getCommandID(camera_sync_cmd))
	{
		HandleCamera(this, params, !canSend(this));
	}
}

void onAttached( CBlob@ this, CBlob@ attached, AttachmentPoint @attachedPoint )
{
	this.ClearMenus();
}