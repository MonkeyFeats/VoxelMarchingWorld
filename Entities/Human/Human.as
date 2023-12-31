#include "HumanCommon.as"
#include "Voxels.as"
#include "Vec3D.as"
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

	this.set_f32("pos_x", 24.5f*8);	// world mid
	this.set_f32("pos_y", 23.0f*8); // 1 below sky max
	this.set_f32("pos_z", 24.5f*8); // world mid

	this.addCommandID(camera_sync_cmd);

	this.set_f32("cam rotation", 0.0f);
	this.set_f32("FOV", 10.5f);
	this.set_u8("CursorDist",5);
	
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
	const bool action3 = this.isKeyPressed( key_action3 );	
	const bool pickup = this.isKeyPressed( key_pickup );		
	const u32 time = getGameTime();
	f32 height = this.get_f32("pos_y");
	string currentTool = this.get_string( "current tool" );

	Vec2f pos = myPos(this); // fake pos
	Vec2f aimpos = this.get_Vec2f("aim_pos");	

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

	Vec3d playerPos(pos.x, height, pos.y);
	//voxmap.LoadChunks(playerPos, 16, 16);
	//voxmap.LoadChunks(playerPos, camRotation);

	//print("x "+int((aimpos.x-0.5)/8)+" y "+int((aimpos.y-0.5)/8)+" z "+Maths::Abs((-16-int((this.get_f32("aim_posZ")-0.5)/8))));

	voxmap.rx = int((aimpos.x-0.5)/8);
	voxmap.ry = Maths::Abs(-16-int((this.get_f32("aim_posZ")/2))-height)/8;
	voxmap.rz = int((aimpos.y-0.5)/8);

	//u8 cd = this.get_u8("CursorDist");
	//if (voxmap.GetBlockAtPosition(int((aimpos.x-0.5)/8), Maths::Abs(-16-int((this.get_f32("aim_posZ")/2))-height)/8, int((aimpos.y-0.5)/8)) == 0)
	//{
	//	if (cd < 5)
	//	cd++;
	//	this.set_u8("CursorDist",cd);
	//}
	//else
	//{
	//	if (cd > 2)
	//	cd--;
	//	this.set_u8("CursorDist",cd);
	//}	

	if (action1)
	{
	
		voxmap.SetBlockAt( Vec3d(int((aimpos.x-0.5)/8),   Maths::Abs(-16-int((this.get_f32("aim_posZ")/2))-height)/8, int((aimpos.y-0.5)/8)), 1);
	}

	if (action2)
	{
		voxmap.SetBlockAt( Vec3d(int((aimpos.x-0.5)/8),  Maths::Abs(-16-int((this.get_f32("aim_posZ")/2))-height)/8, int((aimpos.y-0.5)/8)), 0);
	}

	// move
	Vec2f moveVel(-1,-1);		

	int px = ((pos.x)/8);
	int py = (height/8);
	int pz = ((pos.y)/8);	

	if (up && !down )  		 { moveVel.y = -0.2f; }	
	else if ( down && !up )  { moveVel.y =  0.2f; }	
	else {moveVel.y=0;}

	if ( right && !left ) 	 { moveVel.x = -0.2f; }
	else if (left && !right ){ moveVel.x =  0.2f; }
	else {moveVel.x=0;}

	moveVel.RotateBy( -this.get_f32("dir_x") );
	
//	Vec2f velPos((pos.x-moveVel.x), (pos.y-moveVel.y));
//
//	if (voxmap.isOverlapping( Vec3d(velPos.x/8.0f, py, pz), Vec3d(px, py, pz)) ) 
//    moveVel.x = 0;
//
//    if (voxmap.isOverlapping( Vec3d(px, py, velPos.y/8.0f), Vec3d(px, py, pz)) )
//    moveVel.y = 0; 
//	
	this.set_f32("pos_x", pos.x-moveVel.x);
	this.set_f32("pos_z", pos.y-moveVel.y);
//
//	bool falling = (!(voxmap.isOverlapping( Vec3d(px, py-1, velPos.y/8.0f), Vec3d(px, py, pz)) || voxmap.isOverlapping( Vec3d(velPos.x/8.0f, py-1, pz), Vec3d(px, py, pz))));
//	f32 jumptimer = this.get_f32("jump timer");
//	bool jumping = this.get_bool("jumping");
//	if ( action3 && !jumping && !falling ) 
//	{ 
//		this.set_bool("jumping", true);
//	}
//	else if (jumping)
//	{
//		jumptimer++;
//		height+=2.5-(jumptimer/4);				
//		if(jumptimer == 12.0)
//		{
//			jumptimer = 0;
//			this.set_bool("jumping", false);
//		}
//		
//		this.set_f32("jump timer", jumptimer);
//	}
//	else if (falling && !this.get_bool("stuck"))

	if ( action3 )
	{
		height+=0.2; 
	}
	else if ( pickup )
	{ height-=0.2; }

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