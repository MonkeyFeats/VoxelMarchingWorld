#include "HumanCommon.as"

//const float eye_height = -1.05f;
SColor col(0xffffffff);
float nearDist = 0.1f;
float farDist = 1000.0f;
const float pi = Maths::Pi;
float ratio = f32(getDriver().getScreenWidth()) / f32(getDriver().getScreenHeight());
float fov = 12.0; // 10
float[] cam = {
    1, 0, 0, 0,
    0, 1, 0, 0,
    0, 0, 1, 0,
    0, 0, 0, 1
};
float[] proj;
float[] model;

void RenderProps(Vec2f pos, float[] cam, float dirX, float dirY, float[] proj, f32 eye_height)
{	
	u16 angle;
	//if (angle < 180)
	{
		angle+=0.00002;
	}
	//else {angle = 0;}

	CBlob@[] props;
	getBlobsByTag("prop", @props);
	for(int i = 0; i < props.length; i++)
	{
		CBlob@ prop = props[i];
		if(prop !is null)
		{
			//Render::RawTrianglesIndexed(this.texture, this.v_raw, this.v_i);
			int id = prop.get_u8("ID");
			float[] model;
			Matrix::MakeIdentity(model);						

			switch (id)
			{
				case 0:			// nothin
				{
					break;
				}
				
				case 1:			// fake grob
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, dirX, 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("fakegrob.png", DefaultTriangleVertexes, DefaultTriangleFace);
					break;
				}
				
				case 2:			// box
				{
					Matrix::SetTranslation(model, prop.getPosition().x/8-pos.x, prop.get_f32("aimz")/45-0.5, prop.getPosition().y/8-pos.y);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("box.png", box_Vertexes, box_IDs);
					break;
				}
				
				case 3:			// barrel
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("barrel.png", barrel_Vertexes, barrel_IDs);
					break;
				}
				
				case 4:			// bullet
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height/4, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, -dirY, dirX, 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("Bullet.png", BulletVertexes, DefaultTriangleFace);
					break;
				}

				// ship blobs //
				case 5:	// floor platform1
				{
					if (prop.get_bool("red"))
					for(int i = 0; i < floor_Vertexes.size(); i++)
						floor_Vertexes[i].col = SColor(200,255,0,0);
					else
					for(int i = 0; i < floor_Vertexes.size(); i++)
						floor_Vertexes[i].col = color_white;

					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("FloorWood.png", floor_Vertexes, square_IDs);					
					break;
				}

				case 6:	// floor platform 2
				{
					if (prop.get_bool("red"))
					for(int i = 0; i < floor_Vertexes.size(); i++)
						floor_Vertexes[i].col = SColor(200,255,0,0);
					else
					for(int i = 0; i < floor_Vertexes.size(); i++)
						floor_Vertexes[i].col = color_white;

					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("FloorWood2.png", floor_Vertexes, square_IDs);					
					break;
				}
				case 8:	// ram hull
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("RamHull.png", wall_Vertexes, wall_IDs);
					break;
				}					
				case 34:	// PalmTree
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					f32 y =  Maths::Sin(getGameTime()*0.05)*0.05;
			model[6] = y;
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("PalmTree.png", palm_Vertexes, palm_IDs);					
					break;
				}			
				case 35:	// Coupling
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("Coupling.png", floor_Vertexes, square_IDs);				
					break;
				}
				case 12:	// Door
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("Door.png", wall_Vertexes, wall_IDs);
					break;
				}
				case 17:	// ram engine
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 180, prop.getAngleDegrees()+180, 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SolidWood.png", propeller_Vertexes, propeller_IDs);
					break;
				}

				case 32:	// engine blades
				{					
					Vec2f rotang = Vec2f(0, angle).RotateBy(prop.getAngleDegrees());

					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0 , prop.getAngleDegrees() , 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("FloorWood.png", propellerblades_Vertexes, propellerblades_IDs);
					break;
				}

				case 77:	// Sunken Treasure
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height+0.03, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Matrix::SetScale(model, 5.0, 1.0, 5.0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SunkShip.png", floor_Vertexes, square_IDs);					
					break;
				}

				case 78:	// Sharky
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height-0.85, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SharkTex.png", shark_bod_Vertexes, shark_bod_IDs);

					Vec2f jaw_pivot(0.72, 0);
					jaw_pivot.RotateBy(prop.getAngleDegrees());

					Matrix::SetTranslation(model, jaw_pivot.y+prop.getPosition().y/16-pos.y, eye_height-0.85-0.21, jaw_pivot.x+prop.getPosition().x/16-pos.x);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SharkTex.png", shark_jaw_Vertexes, shark_jaw_IDs);	

					Vec2f tail_pivot(-0.5, 0);
					tail_pivot.RotateBy(prop.getAngleDegrees());

					Matrix::SetTranslation(model, tail_pivot.y+prop.getPosition().y/16-pos.y, eye_height-0.85, tail_pivot.x+prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees()+ (Maths::Sin(getGameTime() * 0.15f) * 12), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SharkTex.png", shark_tail_Vertexes, shark_tail_IDs);
					break;
				}

				case 99:	// station
				{
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height+0.06, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees()+45, 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("Station.png", station_Vertexes, station_IDs);
					break;
				}

				case 9:	// wood wall
				{	
					Matrix::SetTranslation(model, prop.getPosition().y/16-pos.y, eye_height, prop.getPosition().x/16-pos.x);
					Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
					Render::SetModelTransform(model);
					Render::RawTrianglesIndexed("SolidWood.png", wall_Vertexes, wall_IDs);
					break;
				}				
			}
			/*if (objects[id].billboard)
			{
				Matrix::SetTranslation(model, (prop.getInterpolatedPosition().y+prop.getHeight()/2)/16-pos.y, eye_height, (prop.getInterpolatedPosition().x+prop.getWidth()/2)/16-pos.x);
				Matrix::SetRotationDegrees(model, 0, dir, 0);
			}
			else
			{
				Matrix::SetTranslation(model, prop.getInterpolatedPosition().y/16-pos.y, eye_height, prop.getInterpolatedPosition().x/16-pos.x);
				Matrix::SetRotationDegrees(model, 0, prop.getAngleDegrees(), 0);
			}
			
			Render::SetModelTransform(model);
			objects[id].Draw(prop);
			
			if (id == 0)
			{
				Matrix::MakeIdentity(model);
				Matrix::SetTranslation(model, (prop.getInterpolatedPosition().y+prop.getHeight()/2)/16-pos.y, eye_height, (prop.getInterpolatedPosition().x+prop.getWidth()/2)/16-pos.x);
				Matrix::SetRotationDegrees(model, 0, prop.get_f32("dir_x")-45, 0);
				Render::SetModelTransform(model);
				Render::RawTrianglesIndexed("look.png", lookV, lookID);
			}*/
		}
	}
}

void RenderPlayers(Vec2f pos, float[] cam, float dir, float[] proj, f32 eye_height)
{
	string outlinename = "BlockOutlineGreen.png";
	CBlob@[] blobs;
	getBlobsByName("human", @blobs);
	for(int i = 0; i < blobs.length; i++)
	{
		CBlob@ blob = blobs[i];
		if(blob !is null)
		{
			string currentTool = blob.get_string( "current tool" );
			if ( currentTool == "reconstructor" || currentTool == "deconstructor" )
			{
				CBlob@ mBlob = getMap().getBlobAtPosition( blob.get_Vec2f("aim_pos") );
				if (mBlob !is null)
				{
					const bool action1 = blob.isKeyPressed( key_action1 );
					const bool action2 = blob.isKeyPressed( key_action2 );
					if (action1)
					{ outlinename = "BlockOutlineGreen.png"; } 
					else if (action2)
					{ outlinename = "BlockOutlineRed.png"; }
					else 
					{ outlinename = "BlockOutlineWhite.png"; }

					Matrix::SetTranslation(model, mBlob.getPosition().y/16-pos.y, eye_height, mBlob.getPosition().x/16-pos.x);
					Matrix::SetScale(model, 1.03, 1.03, 1.03);
					Render::SetModelTransform(model);
					//Render::SetAlphaBlend(true);
					Render::RawTrianglesIndexed( outlinename, wall_Vertexes, wall_IDs);
				}				
			}

			if(blob.isMyPlayer()) continue;
			
			CSprite@ sprite = blob.getSprite();
			if(sprite !is null)
			{
				f32 bit = 0.2500f;
				u16 frame = sprite.getFrame();
				u8 u = frame/4;
				
				Vec2f Edir = Vec2f(1,0).RotateBy(blob.get_f32("dir_x"));
				Vec2f Cdir = Vec2f(1,0).RotateBy(Vec2f(pos.x*16-blob.getPosition().x, pos.y*16-blob.getPosition().y).getAngleDegrees());
				Edir.RotateBy(360-Cdir.getAngleDegrees());
				f32 newangl = Edir.getAngleDegrees();
				u8 l = 0;
				if(newangl > 45 && newangl < 135) l = 1;
				else if(newangl > 135 && newangl < 225) l = 2;
				else if(newangl > 225 && newangl < 315) l = 3;
				
				Vertex[] vrtxs = 
				{
					Vertex(-0.5, 2.0, 0,	 l*bit,			 f32(u)*bit,		 color_white),
					Vertex(1.5, 0.0, 0,		 (l+1)*bit,		 f32(u+1)*bit,		 color_white),
					Vertex(-0.5, 0.0, 0,	 l*bit,			 f32(u+1)*bit,		 color_white)
				};
				float[] model;
				Matrix::MakeIdentity(model);
				Matrix::SetTranslation(model, (blob.getInterpolatedPosition().y)/16-pos.y, eye_height, (blob.getInterpolatedPosition().x)/16-pos.x);
				Matrix::SetRotationDegrees(model, 0, dir, 0);
				Render::SetModelTransform(model);
				Render::RawTrianglesIndexed("Player"+blob.getTeamNum()+".png", vrtxs, DefaultTriangleFace);
			}
		}
	}
}

float lerp(float v0, float v1, float t)
{
	return (1 - t) * v0 + t * v1;
}

float[] Multiply(float[] first, float[] second)
{
	float[] new(16);
	for(int i = 0; i < 4; i++)
		for(int j = 0; j < 4; j++)
			for(int k = 0; k < 4; k++)
				new[i+j*4] += first[i+k*4] * second[j+k*4];
	return new;
}

// Warning!: mess
/*
Object[] objects = 
{
	Object("fakegrob.png", DefaultTriangleVertexes, DefaultTriangleFace, true),
	Object("box.png", box_Vertexes, box_IDs, false),
	Object("barrel.png", barrel_Vertexes, barrel_IDs, false),
	Object("bullet", bullet_Vertexes, DefaultTriangleFace, true, true)
};*/

Vertex[] BulletVertexes = {Vertex(-0.25, 0.25, 0, 0,0,color_white),Vertex(0.0, 0.0, 0, 1,1,color_white),Vertex(-0.25, 0.0, 0, 0,1,color_white)};

Vertex[] DefaultTriangleVertexes = {Vertex(-0.5, 2.0, 0, 0,0,color_white),Vertex(1.5, 0.0, 0, 1,1,color_white),Vertex(-0.5, 0.0, 0, 0,1,color_white)};
u16[] DefaultTriangleFace = {0,1,2};

Vertex[] GrassVertexes = 
{
	Vertex( 0.0, 0.0, -1.125, -0.079956, 1.0),
	Vertex( 0.0, -0.0, 1.125, 1.079102, 1.0),
	Vertex( -0.0, 1.125, 0.0, 0.5, 0.0),
	Vertex( -1.125, -0.0, -0.0, -0.079956, 1.0),
	Vertex( 1.125, 0.0, 0.0, 1.079102, 1.0),
};
u16[] GrassFace_IDs = {0,1,2,3,4,2};

Vertex[] box_Vertexes = {Vertex(0.25,0,0.25,0,1,color_white),Vertex(0.25,0,-0.25,0,0,color_white),Vertex(-0.25,0,-0.25,1,0,color_white),Vertex(-0.25,0,0.25,1,1,color_white),Vertex(0.250001,0.5,0.25,1,1,color_white),Vertex(-0.25,0.5,0.25,0,1,color_white),Vertex(-0.25,0.5,-0.25,0,0,color_white),Vertex(0.249999,0.5,-0.250001,1,0,color_white),Vertex(0.25,0,0.25,1,1,color_white),Vertex(0.250001,0.5,0.25,0,1,color_white),Vertex(0.249999,0.5,-0.250001,0,0,color_white),Vertex(0.25,0,-0.25,1,0,color_white),Vertex(0.25,0,-0.25,1,1,color_white),Vertex(0.249999,0.5,-0.250001,0,1,color_white),Vertex(-0.25,0,-0.25,1,1,color_white),Vertex(-0.25,0.5,-0.25,0,1,color_white),Vertex(-0.25,0.5,0.25,0,0,color_white),Vertex(-0.25,0,0.25,1,0,color_white),Vertex(0.250001,0.5,0.25,0,0,color_white),Vertex(0.25,0,0.25,1,0,color_white)};
u16[] box_IDs = {1,0,3,1,3,2,5,4,7,5,7,6,9,8,11,9,11,10,13,12,2,13,2,6,15,14,17,15,17,16,19,18,5,19,5,3};

Vertex[] barrel_Vertexes = {Vertex(0,0,0.2,1,0.6,color_white),Vertex(0,0.64,0.2,1,0,color_white),Vertex(0.141421,0.64,0.141421,0.875,0,color_white),Vertex(0.141421,0,0.141421,0.875,0.6,color_white),Vertex(0.2,0.64,-0,0.75,0,color_white),Vertex(0.2,0,-0,0.75,0.6,color_white),Vertex(0.141421,0.64,-0.141421,0.625,0,color_white),Vertex(0.141421,0,-0.141421,0.625,0.6,color_white),Vertex(0,0.64,-0.2,0.5,0,color_white),Vertex(0,0,-0.2,0.5,0.6,color_white),Vertex(-0.141421,0.64,-0.141421,0.375,0,color_white),Vertex(-0.141421,0,-0.141421,0.375,0.6,color_white),Vertex(-0.2,0.64,0,0.25,0,color_white),Vertex(-0.2,0,0,0.25,0.6,color_white),Vertex(0.2,0.64,-0,0.16,1,color_white),Vertex(0.141421,0.64,0.141421,0.26,0.95,color_white),Vertex(0,0.64,0.2,0.32,0.8,color_white),Vertex(-0.141421,0.64,0.141421,0.26,0.65,color_white),Vertex(-0.2,0.64,0,0.16,0.6,color_white),Vertex(-0.141421,0.64,-0.141421,0.06,0.65,color_white),Vertex(0,0.64,-0.2,0,0.8,color_white),Vertex(0.141421,0.64,-0.141421,0.06,0.95,color_white),Vertex(-0.141421,0.64,0.141421,0.125,0,color_white),Vertex(-0.141421,0,0.141421,0.125,0.6,color_white),Vertex(0,0.64,0.2,0,0,color_white),Vertex(0,0,0.2,0,0.6,color_white),Vertex(-0.141421,0,0.141421,0.58,0.65,color_white),Vertex(0,0,0.2,0.64,0.8,color_white),Vertex(0.141421,0,0.141421,0.58,0.95,color_white),Vertex(0.2,0,-0,0.48,1,color_white),Vertex(0.141421,0,-0.141421,0.38,0.95,color_white),Vertex(0,0,-0.2,0.32,0.8,color_white),Vertex(-0.141421,0,-0.141421,0.38,0.65,color_white),Vertex(-0.2,0,0,0.48,0.6,color_white)};
u16[] barrel_IDs = {1,0,3,1,3,2,2,3,5,2,5,4,4,5,7,4,7,6,6,7,9,6,9,8,8,9,11,8,11,10,10,11,13,10,13,12,15,14,16,17,16,18,19,18,20,21,20,14,16,14,18,20,18,14,12,13,23,12,23,22,25,24,22,25,22,23,27,26,28,29,28,30,31,30,32,33,32,26,28,26,30,32,30,26};

Vertex[] lookV = {Vertex(0, 0.01, 1, 0,0,color_white),Vertex(1, 0.01, 0, 1,1,color_white),Vertex(0, 0.01, 0, 0,1,color_white)};
u16[] lookID = {0,1,2};

Vertex[] floor_Vertexes = {Vertex(0.5,0.0,0.5,1,1,color_white),Vertex(-0.5,0.0,0.5,0,1,color_white),Vertex(-0.5,0.0,-0.5,0,0,color_white),Vertex(0.5,0.0,-0.5,1,0,color_white)};
u16[] square_IDs = {1,0,3,1,3,2};

Vertex[] wall_Vertexes = {Vertex( 0.5, 0, 0.5, 0,1,color_white), Vertex( 0.5, 0, -0.5, 0,0,color_white), Vertex(-0.5, 0,-0.5, 1,0,color_white),Vertex(-0.5, 0,	 0.5, 1,1,color_white), Vertex( 0.5, 1.0, 0.5, 1,1,color_white), Vertex(-0.5, 1.0, 0.5, 0,1,color_white),Vertex(-0.5, 1.0,-0.5, 0,0,color_white),Vertex( 0.5, 1.0,-0.5, 1,0,color_white),Vertex( 0.5, 0,	 0.5, 1,1,color_white),Vertex( 0.5, 1.0, 0.5, 0,1,color_white),Vertex( 0.5, 1.0,-0.5, 0,0,color_white),Vertex( 0.5, 0,	-0.5, 1,0,color_white),	Vertex( 0.5, 0,	-0.5, 1,1,color_white),Vertex( 0.5, 1.0,-0.5, 0,1,color_white),	Vertex(-0.5, 0,	-0.5, 1,1,color_white),Vertex(-0.5, 1.0,-0.5, 0,1,color_white),	Vertex(-0.5, 1.0, 0.5, 0,0,color_white),Vertex(-0.5, 0,	 0.5, 1,0,color_white),	Vertex( 0.5, 1.0, 0.5, 0,0,color_white),Vertex( 0.5, 0,	 0.5, 1,0,color_white)
};
u16[] wall_IDs = {1,0,3,1,3,2,5,4,7,5,7,6,9,8,11,9,11,10,13,12,2,13,2,6,15,14,17,15,17,16,19,18,5,19,5,3};

Vertex[] propeller_Vertexes = 
{
Vertex( -0.26265, 0.0, -0.17545, 0.307373, 0.977539, color_white),
Vertex( -0.2024, -0.32115, -0.17545, 0.465576, 0.349609, color_white),
Vertex( -0.625, 0.0, -0.1775, -0.651367, 1.0, color_white),
Vertex( -0.2024, -0.32115, -0.17545, 0.19873, 0.349609, color_white),
Vertex( -0.25, -0.25, -0.25, 0.0, 0.48877, color_white),
Vertex( -0.625, 0.0, -0.1775, 0.146729, 1.0, color_white),
Vertex( -0.25, -0.25, -0.25, 0.658691, 0.48877, color_white),
Vertex( -0.25, 0.0, -0.25, 0.658691, 0.977539, color_white),
Vertex( -0.625, 0.0, -0.1775, 1.651367, 1.0, color_white),
Vertex( -0.25, 0.0, 0.25, 0.34082, 0.977539, color_white),
Vertex( -0.25, -0.25, 0.25, 0.34082, 0.48877, color_white),
Vertex( -0.625, 0.0, 0.1775, -0.651367, 1.0, color_white),
Vertex( -0.25, -0.25, 0.25, 1.0, 0.48877, color_white),
Vertex( -0.2024, -0.32115, 0.17545, 0.800781, 0.349609, color_white),
Vertex( -0.625, 0.0, 0.1775, 0.853027, 1.0, color_white),
Vertex( -0.2024, -0.32115, 0.17545, 0.53418, 0.349609, color_white),
Vertex( -0.26265, 0.0, 0.17545, 0.692383, 0.977539, color_white),
Vertex( -0.625, 0.0, 0.1775, 1.651367, 1.0, color_white),
Vertex( -0.2024, -0.32115, 0.17545, 0.800781, 0.349609, color_white),
Vertex( -0.25, -0.25, 0.25, 1.0, 0.48877, color_white),
Vertex( 0.0, -0.4713, 0.25, 1.0, 0.056183, color_white),
Vertex( 0.0, -0.4713, -0.25, 0.0, 0.056183, color_white),
Vertex( -0.25, -0.25, -0.25, 0.0, 0.48877, color_white),
Vertex( -0.2024, -0.32115, -0.17545, 0.19873, 0.349609, color_white),
Vertex( 0.0, -0.4713, 0.25, 0.996094, 1.0, color_white),
Vertex( 0.25, -0.5, -0.25, 1.651367, 0.0, color_white),
Vertex( 0.0, -0.4713, -0.25, 0.996094, 0.0, color_white),
Vertex( 0.25, -0.5, 0.25, 1.651367, 1.0, color_white),
Vertex( 0.25, 0.0, 0.25, 0.0, 0.977539, color_white),
Vertex( 0.25, 0.0, -0.25, 1.0, 0.977539, color_white),
Vertex( 0.25, -0.5, 0.25, 0.0, 0.0, color_white),
Vertex( 0.25, -0.5, -0.25, 1.0, 0.0, color_white),
Vertex( 0.0, -0.4713, -0.25, 0.996094, 0.0, color_white),
Vertex( -0.2024, -0.32115, 0.17545, 0.465576, 0.800781, color_white),
Vertex( 0.0, -0.4713, 0.25, 0.996094, 1.0, color_white),
Vertex( -0.2024, -0.32115, -0.17545, 0.465576, 0.19873, color_white),
Vertex( -0.26265, 0.0, -0.17545, 0.19873, 0.977539, color_white),
Vertex( -0.26265, 0.0, 0.17545, 0.800781, 0.977539, color_white),
Vertex( -0.2024, -0.32115, 0.17545, 0.800781, 0.349609, color_white),
Vertex( -0.2024, -0.32115, -0.17545, 0.19873, 0.349609, color_white),
Vertex( -0.25, 0.0, 0.25, 0.34082, 0.977539, color_white),
Vertex( 0.25, 0.0, 0.25, 1.651367, 0.977539, color_white),
Vertex( -0.25, -0.25, 0.25, 0.34082, 0.48877, color_white),
Vertex( 0.0, -0.4713, 0.25, 0.996094, 0.056183, color_white),
Vertex( 0.25, -0.5, 0.25, 1.651367, 0.0, color_white),
Vertex( 0.25, 0.0, -0.25, -0.651367, 0.977539, color_white),
Vertex( 0.0, -0.4713, -0.25, 0.003799, 0.056183, color_white),
Vertex( 0.25, -0.5, -0.25, -0.651367, 0.0, color_white),
Vertex( -0.25, -0.25, -0.25, 0.658691, 0.48877, color_white),
Vertex( -0.25, 0.0, -0.25, 0.658691, 0.977539, color_white)
};

u16[] propeller_IDs = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,24,27,25,28,29,30,29,31,30,32,33,34,32,35,33,36,37,38,38,39,36,40,41,42,41,43,42,41,44,43,45,46,47,45,48,46,45,49,48};

Vertex[] propellerblades_Vertexes = 
{
 Vertex( 0.206905, 0.206905, -0.1778,  0.0, 0.5, color_white),
 Vertex( 0.206905, 0.206905, 0.1778,  1.0, 0.5, color_white),
 Vertex( 0.19656, 0.21725, 0.1778,  1.0, 0.474854, color_white),
 Vertex( 0.19656, 0.21725, -0.1778,  0.0, 0.474854, color_white),
 Vertex( -0.206905, -0.206905, 0.1778,  0.0, 0.5, color_white),
 Vertex( -0.206905, -0.206905, -0.1778,  1.0, 0.5, color_white),
 Vertex( -0.21725, -0.19656, -0.1778,  1.0, 0.474854, color_white),
 Vertex( -0.21725, -0.19656, 0.1778,  0.0, 0.474854, color_white),
 Vertex( 0.0, -0.0, -0.1778,  0.5, 1.0, color_white),
 Vertex( -0.206905, -0.206905, -0.1778,  1.0, 1.0, color_white),
 Vertex( -0.206905, -0.206905, 0.1778,  1.0, 0.0, color_white),
 Vertex( -0.0, 0.0, 0.1778,  0.5, 0.0, color_white),
 Vertex( -0.010345, 0.010345, 0.1778,  0.5, 0.0, color_white),
 Vertex( -0.21725, -0.19656, 0.1778,  0.0, 0.0, color_white),
 Vertex( -0.21725, -0.19656, -0.1778,  0.0, 1.0, color_white),
 Vertex( -0.010345, 0.010345, -0.1778,  0.5, 1.0, color_white),
 Vertex( 0.010345, 0.010345, 0.1778,  0.474854, 0.0, color_white),
 Vertex( 0.206905, 0.206905, 0.1778,  0.0, 0.0, color_white),
 Vertex( 0.206905, 0.206905, -0.1778,  0.0, 1.0, color_white),
 Vertex( 0.010345, 0.010345, -0.1778,  0.474854, 1.0, color_white),
 Vertex( 0.19656, 0.21725, 0.1778,  1.0, 0.0, color_white),
 Vertex( 0.0, 0.020691, 0.1778,  0.524902, 0.0, color_white),
 Vertex( 0.0, 0.020691, -0.1778,  0.524902, 1.0, color_white),
 Vertex( 0.19656, 0.21725, -0.1778,  1.0, 1.0, color_white),
 Vertex( -0.0, 0.0, 0.1778,  0.0, 0.5, color_white),
 Vertex( 0.206905, -0.206905, 0.1778,  0.0, 1.0, color_white),
 Vertex( 0.206905, -0.206905, -0.1778,  1.0, 1.0, color_white),
 Vertex( 0.0, -0.0, -0.1778,  1.0, 0.5, color_white),
 Vertex( 0.21725, -0.19656, 0.1778,  0.474854, 0.0, color_white),
 Vertex( 0.21725, -0.19656, -0.1778,  0.474854, 1.0, color_white),
 Vertex( 0.206905, -0.206905, -0.1778,  0.5, 1.0, color_white),
 Vertex( 0.206905, -0.206905, 0.1778,  0.5, 0.0, color_white),
 Vertex( 0.010345, 0.010345, 0.1778,  1.0, 0.5, color_white),
 Vertex( 0.010345, 0.010345, -0.1778,  0.0, 0.5, color_white),
 Vertex( 0.21725, -0.19656, -0.1778,  0.0, 1.0, color_white),
 Vertex( 0.21725, -0.19656, 0.1778,  1.0, 1.0, color_white),
 Vertex( -0.19656, 0.21725, -0.1778,  0.0, 0.0, color_white),
 Vertex( 0.0, 0.020691, -0.1778,  0.0, 0.474854, color_white),
 Vertex( 0.0, 0.020691, 0.1778,  1.0, 0.474854, color_white),
 Vertex( -0.19656, 0.21725, 0.1778,  1.0, 0.0, color_white),
 Vertex( -0.010345, 0.010345, -0.1778,  1.0, 0.474854, color_white),
 Vertex( -0.206905, 0.206905, -0.1778,  1.0, 0.0, color_white),
 Vertex( -0.206905, 0.206905, 0.1778,  0.0, 0.0, color_white),
 Vertex( -0.010345, 0.010345, 0.1778,  0.0, 0.474854, color_white),
 Vertex( -0.206905, 0.206905, 0.1778,  0.5, 0.0, color_white),
 Vertex( -0.206905, 0.206905, -0.1778,  0.5, 1.0, color_white),
 Vertex( -0.19656, 0.21725, -0.1778,  0.524902, 1.0, color_white),
 Vertex( -0.19656, 0.21725, 0.1778,  0.524902, 0.0, color_white),
 Vertex( 0.206905, -0.206905, -0.1778,  0.5, 1.0, color_white),
 Vertex( 0.21725, -0.19656, -0.1778,  0.524902, 1.0, color_white),
 Vertex( 0.010345, 0.010345, -0.1778,  0.524902, 0.5, color_white),
 Vertex( 0.0, -0.0, -0.1778,  0.5, 0.5, color_white),
 Vertex( 0.206905, 0.206905, -0.1778,  1.0, 0.5, color_white),
 Vertex( 0.19656, 0.21725, -0.1778,  1.0, 0.474854, color_white),
 Vertex( 0.0, 0.020691, -0.1778,  0.524902, 0.474854, color_white),
 Vertex( -0.010345, 0.010345, -0.1778,  0.5, 0.474854, color_white),
 Vertex( -0.19656, 0.21725, -0.1778,  0.524902, 0.0, color_white),
 Vertex( -0.206905, 0.206905, -0.1778,  0.5, 0.0, color_white),
 Vertex( -0.206905, -0.206905, -0.1778,  0.0, 0.5, color_white),
 Vertex( -0.21725, -0.19656, -0.1778,  0.0, 0.474854, color_white),
 Vertex( -0.010345, 0.010345, 0.1778,  0.5, 0.474854, color_white),
 Vertex( -0.206905, 0.206905, 0.1778,  0.5, 0.0, color_white),
 Vertex( -0.19656, 0.21725, 0.1778,  0.474854, 0.0, color_white),
 Vertex( 0.0, 0.020691, 0.1778,  0.474854, 0.474854, color_white),
 Vertex( -0.206905, -0.206905, 0.1778,  1.0, 0.5, color_white),
 Vertex( -0.21725, -0.19656, 0.1778,  1.0, 0.474854, color_white),
 Vertex( -0.0, 0.0, 0.1778,  0.5, 0.5, color_white),
 Vertex( 0.010345, 0.010345, 0.1778,  0.474854, 0.5, color_white),
 Vertex( 0.19656, 0.21725, 0.1778,  0.0, 0.474854, color_white),
 Vertex( 0.206905, 0.206905, 0.1778,  0.0, 0.5, color_white),
 Vertex( 0.206905, -0.206905, 0.1778,  0.5, 1.0, color_white),
 Vertex( 0.21725, -0.19656, 0.1778,  0.474854, 1.0, color_white)
};

u16[] propellerblades_IDs = {0,1,2,2,3,0,4,5,6,6,7,4,8,9,10,10,11,8,12,13,14,14,15,12,16,17,18,18,19,16,20,21,22,22,23,20,24,25,26,26,27,24,28,29,30,30,31,28,32,33,34,34,35,32,36,37,38,38,39,36,40,41,42,42,43,40,44,45,46,46,47,44,48,49,50,51,48,50,50,52,53,50,53,54,51,50,54,51,54,55,56,51,55,56,55,57,54,58,55,58,59,55,60,61,62,60,62,63,60,64,65,60,66,64,60,63,66,63,67,66,63,68,67,68,69,67,67,70,66,67,71,70};

Vertex[] station_Vertexes = 
{
 Vertex( -0.96, 0.17, 0.31, 0.639648, 0.919922),
Vertex( -0.96, 0.17, -0.31, 0.359863, 0.919922),
Vertex( -1.06, 0.04, -0.35, 0.349854, 0.959961),
Vertex( -1.06, 0.04, 0.35, 0.649902, 0.959961),
Vertex( -0.35, 0.04, -1.06, 0.039978, 0.649902),
Vertex( -0.31, 0.17, 0.96, 0.919922, 0.629883),
Vertex( -0.31, 0.17, -0.96, 0.079956, 0.629883),
Vertex( -0.35, 0.04, 1.06, 0.959961, 0.649902),
Vertex( 0.35, 0.04, -1.06, 0.039978, 0.349854),
Vertex( 0.31, 0.17, 0.96, 0.919922, 0.359863),
Vertex( 0.31, 0.17, -0.96, 0.079956, 0.359863),
Vertex( 0.35, 0.04, 1.06, 0.959961, 0.349854),
Vertex( 1.06, 0.04, -0.35, 0.349854, 0.039978),
Vertex( 0.96, 0.17, 0.31, 0.639648, 0.079956),
Vertex( 0.96, 0.17, -0.31, 0.359863, 0.079956),
Vertex( 1.06, 0.04, 0.35, 0.649902, 0.039978),
Vertex( -0.96, 0.17, -0.31, 0.359863, 0.919922),
Vertex( -0.96, 0.17, 0.31, 0.639648, 0.919922),
Vertex( -0.89, 0.17, 0.27, 0.619629, 0.889648),
Vertex( -0.89, 0.17, -0.27, 0.379883, 0.889648),
Vertex( -0.31, 0.17, -0.96, 0.079956, 0.629883),
Vertex( -0.27, 0.17, 0.89, 0.889648, 0.619629),
Vertex( -0.31, 0.17, 0.96, 0.919922, 0.629883),
Vertex( -0.27, 0.17, -0.89, 0.109985, 0.619629),
Vertex( 0.31, 0.17, -0.96, 0.079956, 0.359863),
Vertex( 0.27, 0.17, 0.89, 0.889648, 0.379883),
Vertex( 0.31, 0.17, 0.96, 0.919922, 0.359863),
Vertex( 0.27, 0.17, -0.89, 0.109985, 0.379883),
Vertex( 0.96, 0.17, -0.31, 0.359863, 0.079956),
Vertex( -0.66, 0.07, -0.17, 0.429932, 0.779785),
Vertex( 0.89, 0.17, -0.27, 0.379883, 0.109985),
Vertex( 0.96, 0.17, 0.31, 0.639648, 0.079956),
Vertex( -0.17, 0.07, -0.66, 0.209961, 0.569824),
Vertex( 0.17, 0.07, -0.66, 0.209961, 0.419922),
Vertex( -0.66, 0.07, 0.17, 0.569824, 0.779785),
Vertex( 0.66, 0.07, -0.17, 0.429932, 0.209961),
Vertex( 0.89, 0.17, 0.27, 0.619629, 0.109985),
Vertex( 0.66, 0.07, 0.17, 0.569824, 0.209961),
Vertex( 0.17, 0.07, 0.66, 0.789551, 0.419922),
Vertex( -0.17, 0.07, 0.66, 0.789551, 0.569824)
};

u16[] station_IDs = {0,1,2,2,3,0,4,2,1,5,0,3,1,6,4,3,7,5,8,4,6,9,5,7,6,10,8,7,11,9,12,8,10,13,9,11,10,14,12,11,15,13,15,12,14,14,13,15,16,17,18,18,19,16,20,16,19,21,18,17,17,22,21,19,23,20,24,20,23,25,21,22,22,26,25,23,27,24,28,24,27,23,19,29,27,30,28,31,28,30,27,23,32,29,32,23,30,27,33,32,33,27,34,29,19,32,29,34,19,18,34,35,33,32,33,35,30,35,32,34,30,36,31,36,30,35,26,31,36,36,25,26,35,37,36,25,36,37,35,38,37,37,38,25,35,34,38,21,25,38,34,39,38,38,39,21,39,34,18,18,21,39};

Vertex[] palm_Vertexes = 
{
 Vertex( 0.337382, -0.0, 0.025375,  0.398438, 0.992188, color_white),
 Vertex( 0.117995, -0.0, 0.327336,  0.492188, 0.992188, color_white),
 Vertex( 0.071719, 1.021567, 0.330572,  0.492188, 0.804688, color_white),
 Vertex( 0.290121, 1.043312, 0.02868,  0.398438, 0.804688, color_white),
 Vertex( 0.117995, -0.0, -0.276585,  0.304688, 0.992188, color_white),
 Vertex( -0.016601, 2.067155, 0.316878,  0.492188, 0.617188, color_white),
 Vertex( 0.071546, 1.025385, -0.273337,  0.304688, 0.804688, color_white),
 Vertex( -0.236981, -0.0, -0.161246,  0.195313, 0.992188, color_white),
 Vertex( 0.201323, 2.054591, 0.014041,  0.398438, 0.617188, color_white),
 Vertex( 0.044563, 3.156288, 0.164058,  0.492188, 0.414063, color_white),
 Vertex( -0.281943, 0.992562, -0.158102,  0.195313, 0.804688, color_white),
 Vertex( -0.236981, -0.0, 0.211997,  0.085938, 0.992188, color_white),
 Vertex( -0.019391, 2.032015, -0.286016,  0.304688, 0.617188, color_white),
 Vertex( 0.233906, 3.089081, -0.107847,  0.398438, 0.414063, color_white),
 Vertex( 0.129425, 4.162159, -0.041328,  0.492188, 0.210938, color_white),
 Vertex( -0.281836, 0.990203, 0.215134,  0.085938, 0.804688, color_white),
 Vertex( 0.117995, -0.0, 0.327336,  0.007813, 0.992188, color_white),
 Vertex( 0.071719, 1.021567, 0.330572,  0.007813, 0.804688, color_white),
 Vertex( -0.373997, 2.023628, -0.168497,  0.195313, 0.617188, color_white),
 Vertex( -0.372645, 2.042269, 0.204286,  0.085938, 0.617188, color_white),
 Vertex( -0.016601, 2.067155, 0.316878,  0.007813, 0.617188, color_white),
 Vertex( 0.027851, 3.069182, -0.374535,  0.304688, 0.414063, color_white),
 Vertex( -0.290812, 3.11505, -0.266534,  0.195313, 0.414063, color_white),
 Vertex( -0.281884, 3.165024, 0.066988,  0.085938, 0.414063, color_white),
 Vertex( 0.044563, 3.156288, 0.164058,  0.007813, 0.414063, color_white),
 Vertex( 0.294409, 4.114699, -0.280726,  0.398438, 0.210938, color_white),
 Vertex( 0.103907, 5.157367, -0.279248,  0.492188, 0.007813, color_white),
 Vertex( 0.214658, 5.1369, -0.441736,  0.398438, 0.007813, color_white),
 Vertex( 0.113663, 4.085351, -0.511491,  0.304688, 0.210938, color_white),
 Vertex( 0.093333, 5.107819, -0.595104,  0.304688, 0.007813, color_white),
 Vertex( -0.163028, 4.114673, -0.414715,  0.195313, 0.210938, color_white),
 Vertex( -0.092402, 5.110312, -0.527402,  0.195313, 0.007813, color_white),
 Vertex( -0.153286, 4.162144, -0.124138,  0.085938, 0.210938, color_white),
 Vertex( -0.085867, 5.140934, -0.332193,  0.085938, 0.007813, color_white),
 Vertex( 0.129425, 4.162159, -0.041328,  0.007813, 0.210938, color_white),
 Vertex( 0.103907, 5.157367, -0.279248,  0.007813, 0.007813, color_white),
 Vertex( -0.02021, 5.233522, -0.427007,  0.75, 0.005985, color_white),
 Vertex( 0.864045, 4.872897, -1.379507,  0.520508, 0.256592, color_white),
 Vertex( 0.926868, 5.065452, -0.427007,  0.755371, 0.255127, color_white),
 Vertex( 0.878717, 4.917867, 0.525493,  0.987793, 0.246826, color_white),
 Vertex( 1.737981, 4.480642, -1.323729,  0.53125, 0.506348, color_white),
 Vertex( 1.766675, 4.568591, 0.470801,  0.983398, 0.496338, color_white),
 Vertex( 1.865949, 4.872869, -0.427007,  0.760742, 0.494141, color_white),
 Vertex( 2.71336, 4.399314, -0.427007,  0.763672, 0.724609, color_white),
 Vertex( 2.616894, 4.103643, -1.148783,  0.584961, 0.752441, color_white),
 Vertex( 2.631621, 4.148784, 0.294768,  0.938965, 0.745117, color_white),
 Vertex( 3.451669, 3.591359, -0.427007,  0.764648, 0.994141, color_white),
 Vertex( 0.100918, 5.266519, -0.394201,  0.75, 0.005985, color_white),
 Vertex( -0.61693, 4.660201, -0.955673,  0.520508, 0.256592, color_white),
 Vertex( 0.157731, 4.802909, -1.019661,  0.755371, 0.255127, color_white),
 Vertex( 0.925736, 4.738498, -0.880256,  0.987793, 0.246826, color_white),
 Vertex( -0.519362, 4.061571, -1.444082,  0.53125, 0.506348, color_white),
 Vertex( 0.934739, 4.163085, -1.400297,  0.983398, 0.496338, color_white),
 Vertex( 0.214065, 4.324371, -1.630463,  0.760742, 0.494141, color_white),
 Vertex( 0.264899, 3.674746, -2.073252,  0.763672, 0.724609, color_white),
 Vertex( -0.325046, 3.475416, -1.935213,  0.584961, 0.752441, color_white),
 Vertex( 0.844155, 3.541483, -1.884679,  0.938965, 0.745117, color_white),
 Vertex( 0.309189, 2.821497, -2.316081,  0.764648, 0.994141, color_white),
 Vertex( 0.177676, 5.221665, -0.257947,  0.75, 0.005985, color_white),
 Vertex( -0.743431, 4.76071, 0.612855,  0.520508, 0.256592, color_white),
 Vertex( -0.74007, 4.946517, -0.343045,  0.755371, 0.255127, color_white),
 Vertex( -0.588185, 4.807086, -1.285832,  0.987793, 0.246826, color_white),
 Vertex( -1.558165, 4.271298, 0.480858,  0.53125, 0.506348, color_white),
 Vertex( -1.431827, 4.358574, -1.309483,  0.983398, 0.496338, color_white),
 Vertex( -1.647111, 4.64793, -0.427198,  0.760742, 0.494141, color_white),
 Vertex( -2.431466, 4.080681, -0.500519,  0.763672, 0.724609, color_white),
 Vertex( -2.368621, 3.796685, 0.229607,  0.584961, 0.752441, color_white),
 Vertex( -2.25581, 3.842407, -1.209587,  0.938965, 0.745117, color_white),
 Vertex( -3.069804, 3.193684, -0.560947,  0.764648, 0.994141, color_white),
 Vertex( 0.067412, 5.162999, -0.267061,  0.75, 0.005985, color_white),
 Vertex( 0.451993, 4.773621, 0.732231,  0.520508, 0.256592, color_white),
 Vertex( -0.293777, 4.930576, 0.422652,  0.755371, 0.255127, color_white),
 Vertex( -0.981607, 4.812796, 0.001242,  0.987793, 0.246826, color_white),
 Vertex( 0.087241, 4.360205, 1.326401,  0.53125, 0.506348, color_white),
 Vertex( -1.270992, 4.433928, 0.652788,  0.983398, 0.496338, color_white),
 Vertex( -0.65079, 4.678353, 1.104304,  0.760742, 0.494141, color_white),
 Vertex( -0.959943, 4.199187, 1.693581,  0.763672, 0.724609, color_white),
 Vertex( -0.369312, 3.95929, 1.878933,  0.584961, 0.752441, color_white),
 Vertex( -1.457535, 3.997912, 1.328648,  0.938965, 0.745117, color_white),
 Vertex( -1.212135, 3.449923, 2.172913,  0.764648, 0.994141, color_white),
 Vertex( -0.040297, 5.270026, -0.520065,  0.75, 0.005985, color_white),
 Vertex( 1.267302, 4.793492, -0.434299,  0.520508, 0.256592, color_white),
 Vertex( 0.540511, 4.985579, 0.235282,  0.755371, 0.255127, color_white),
 Vertex( -0.280772, 4.841436, 0.783084,  0.987793, 0.246826, color_white),
 Vertex( 1.740137, 4.28754, 0.275958,  0.53125, 0.506348, color_white),
 Vertex( 0.294498, 4.377766, 1.439066,  0.983398, 0.496338, color_white),
 Vertex( 1.11451, 4.676901, 0.981853,  0.760742, 0.494141, color_white),
 Vertex( 1.610452, 4.090482, 1.627828,  0.763672, 0.724609, color_white),
 Vertex( 2.119587, 3.796888, 1.066824,  0.584961, 0.752441, color_white),
 Vertex( 0.949577, 3.844155, 1.993279,  0.938965, 0.745117, color_white),
 Vertex( 2.013495, 3.173508, 2.15408,  0.764648, 0.994141, color_white)
};

u16[] palm_IDs = { 0,1,2,0,2,3,4,0,3,3,2,5,4,3,6,7,4,6,3,5,8,6,3,8,8,5,9,7,6,10,11,7,10,6,8,12,10,6,12,8,9,13,12,8,13,13,9,14,11,10,15,16,11,15,16,15,17,10,12,18,15,10,18,17,15,19,15,18,19,17,19,20,18,12,21,12,13,21,19,18,22,18,21,22,20,19,23,19,22,23,20,23,24,21,13,25,13,14,25,25,14,26,25,26,27,21,25,28,28,25,27,22,21,28,28,27,29,22,28,30,30,28,29,23,22,30,30,29,31,23,30,32,32,30,31,24,23,32,32,31,33,24,32,34,34,32,33,34,33,35,36,37,38,36,38,39,38,37,40,39,38,41,38,40,42,38,42,41,42,40,43,41,42,43,40,44,43,41,43,45,43,44,46,45,43,46,47,48,49,47,49,50,49,48,51,50,49,52,49,51,53,49,53,52,53,51,54,52,53,54,51,55,54,52,54,56,54,55,57,56,54,57,58,59,60,58,60,61,60,59,62,61,60,63,60,62,64,60,64,63,64,62,65,63,64,65,62,66,65,63,65,67,65,66,68,67,65,68,69,70,71,69,71,72,71,70,73,72,71,74,71,73,75,71,75,74,75,73,76,74,75,76,73,77,76,74,76,78,76,77,79,78,76,79,80,81,82,80,82,83,82,81,84,83,82,85,82,84,86,82,86,85,86,84,87,85,86,87,84,88,87,85,87,89,87,88,90,89,87,90};

Vertex[] SandFull1_Vertexes = 
{
Vertex( 0.0, -0.0, 0.5, 0.0, 0.649902),
Vertex( 0.5, 0.0, 0.5, 0.0, 0.719727),
Vertex( -0.0, 0.04, 0.21, 0.039978, 0.649902),
Vertex( -0.5, -0.0, 0.5, 0.0, 0.55957),
Vertex( 0.5, 0.0, 0.0, 0.079956, 0.719727),
Vertex( -0.5, -0.0, -0.0, 0.079956, 0.55957),
Vertex( 0.0, -0.04, -0.23, 0.109985, 0.649902),
Vertex( 0.5, 0.0, -0.5, 0.159912, 0.719727),
Vertex( -0.5, 0.0, -0.5, 0.159912, 0.55957),
Vertex( 0.0, 0.0, -0.5, 0.159912, 0.649902)
};

u16[] SandFull1_IDs = {0,1,2,3,0,2,1,4,2,3,2,5,2,4,6,2,6,5,6,4,7,5,6,8,6,7,9,6,9,8};

Vertex[] MountainCorner_Vertexes = 
{ 
	Vertex( 0.5, 2.5, 0.2, 0.25, -1.099609),
	Vertex( 0.5, 3.0, -0.5, 0.119995, -1.55957),
	Vertex( 0.14, 2.43, -0.08, 0.119995, -1.099609),
	Vertex( 0.5, 3.0, -0.5, 0.119995, -1.55957),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.149414),
	Vertex( 0.14, 2.43, -0.08, 0.119995, -1.099609),
	Vertex( 0.5, 0.0, 0.5, 0.5, 1.0),
	Vertex( 0.5, 0.0, 0.3, 0.449951, 1.0),
	Vertex( 0.15, 0.02, 0.25, 0.439941, 0.619629),
	Vertex( -0.5, -0.0, 0.5, 0.5, 0.0),
	Vertex( -0.13, -0.0, 0.25, 0.439941, 0.339844),
	Vertex( -0.25, -0.0, -0.0, 0.379883, 0.219971),
	Vertex( -0.5, 0.0, -0.5, 0.25, 0.0),
	Vertex( -0.3, 0.0, -0.5, 0.25, 0.199951),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.149414),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.25, -0.0, -0.0, 0.089966, 1.0),
	Vertex( -0.1, 1.28, -0.03, 0.099976, 0.0),
	Vertex( -0.13, -0.0, 0.25, 0.159912, 1.0),
	Vertex( 0.15, 0.02, 0.25, 0.199951, 1.0),
	Vertex( 0.16, 1.94, 0.07, 0.139893, -0.659668),
	Vertex( 0.14, 2.43, -0.08, 0.119995, -1.099609),
	Vertex( 0.5, 0.0, 0.3, 0.25, 1.0),
	Vertex( 0.5, 2.5, 0.2, 0.25, -1.099609)
};

u16[] MountainCorner_IDs = {0,1,2,3,4,5,6,7,8,6,8,9,8,10,9,10,11,9,11,12,9,11,13,12,14,15,16,17,14,16,17,16,18,19,17,18,14,17,20,19,20,17,21,14,20,19,22,20,23,21,20,23,20,22};

Vertex[] Rock_straight_Vertexes = 
{
	Vertex( 0.5, 3.0, 0.5, 1.0, -2.0),
 	Vertex( 0.5, 3.0, -0.5, 0.0, -2.0),
 	Vertex( 0.2, 2.68, 0.26, 0.679688, -1.799805),
 	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
 	Vertex( -0.04, 2.62, -0.21, 0.319824, -1.639648),
 	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
 	Vertex( -0.35, 2.07, 0.06, 0.599609, -1.0),
 	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
 	Vertex( -0.38, 0.02, 0.05, 0.599609, 1.0),
 	Vertex( -0.25, 1.3, -0.11, 0.349854, -0.5),
 	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0)
};
u16[] Rock_straight_IDs = {0,1,2,3,0,2,1,4,2,3,2,4,1,5,4,5,3,4,3,5,6,3,6,7,8,7,6,5,9,6,8,6,9,9,5,10,8,9,10};

Vertex[] Rock_concave_Vertexes = 
{
	Vertex( -0.5, -0.0, 0.3, 0.699707, 1.0),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( -0.5, 2.5, 0.2, 0.699707, -1.5),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( -0.5, 2.5, 0.2, 0.369873, 0.82959),
	Vertex( -0.2, 2.5, 0.5, 0.629883, 0.82959),
	Vertex( -0.22, 2.7, 0.2, 0.469971, 0.669922),
	Vertex( -0.5, 3.0, -0.5, 0.059998, 0.549805),
	Vertex( 0.5, 3.0, 0.5, 0.949707, 0.549805),
	Vertex( -0.08, 2.94, -0.17, 0.399902, 0.369873),
	Vertex( 0.5, 3.0, -0.5, 0.509766, 0.049988)
};
u16[] Rock_concave_IDs = {0,1,2,1,3,2,4,5,6,7,4,6,5,8,6,7,6,9,8,9,6,10,7,9,8,10,9};

Vertex[] Rock_peninsula_Vertexes = 
{
	Vertex( 0.5, 0.0, 0.3, 1.0, 1.0),
	Vertex( 0.5, 2.5, 0.2, 1.0, -2.0),
	Vertex( -0.0, 0.03, 0.25, 0.779785, 1.0),
	Vertex( -0.01, 2.04, 0.09, 0.5, -1.40918),
	Vertex( -0.25, 0.04, 0.14, 0.619629, 1.0),
	Vertex( -0.09, 1.64, -0.12, 0.329834, -0.889648),
	Vertex( -0.25, 0.02, -0.14, 0.419922, 1.0),
	Vertex( -0.0, 0.03, -0.25, 0.219971, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.0, -2.0),
	Vertex( 0.5, 2.5, 0.2, 0.299805, -2.0),
	Vertex( 0.5, 0.0, -0.3, 0.0, 1.0)
};
u16[] Rock_peninsula_IDs = {0,1,2,1,3,2,4,2,3,4,3,5,4,5,6,5,7,6,8,5,3,5,8,7,9,8,3,8,10,7};

Vertex[] Rock_strip_Vertexes = 
{
	Vertex( 0.2, 2.5, 0.5, 1.0, -2.0),
 	Vertex( 0.2, 2.5, -0.5, 0.0, -2.0),
 	Vertex( 0.09, 2.67, 0.25, 0.759766, -1.769531),
 	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
 	Vertex( -0.09, 2.67, -0.19, 0.399902, -1.669922),
 	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
 	Vertex( -0.46, 1.99, 0.12, 0.539551, -0.869629),
 	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
 	Vertex( -0.42, 1.22, -0.06, 0.379883, 0.0),
 	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
 	Vertex( 0.3, -0.0, 0.5, 0.0, 1.0),
 	Vertex( 0.3, 0.0, -0.5, 1.0, 1.0),
 	Vertex( 0.43, 0.85, -0.13, 0.599609, 0.179932),
 	Vertex( 0.2, 2.5, -0.5, 1.0, -1.5),
 	Vertex( 0.21, 1.73, 0.19, 0.269775, -0.699707),
 	Vertex( 0.2, 2.5, 0.5, 0.0, -1.5)
};
u16[] Rock_strip_IDs = {0,1,2,3,0,2,2,1,4,3,2,4,1,5,4,5,3,4,3,5,6,7,3,6,5,8,6,7,6,8,5,9,8,9,7,8,10,11,12,11,13,12,10,12,14,13,14,12,15,10,14,13,15,14};

Vertex[] Rock_island_Vertexes = 
{
	Vertex( -0.0, 1.35, -0.38, 0.0, -0.659668),
	Vertex( 0.0, 0.0, -0.34, 0.0, 1.0),
	Vertex( -0.26, 0.0, -0.26, 0.129883, 1.0),
	Vertex( -0.31, 1.36, -0.14, 0.189941, -0.659668),
	Vertex( -0.34, -0.0, -0.0, 0.25, 1.0),
	Vertex( -0.17, 2.55, -0.1, 0.0, -1.699219),
	Vertex( -0.26, -0.0, 0.26, 0.369873, 1.0),
	Vertex( -0.0, 2.75, 0.1, 0.299805, -2.0),
	Vertex( -0.06, 1.35, 0.29, 0.449951, -0.649902),
	Vertex( 0.0, -0.0, 0.34, 0.48999, 1.0),
	Vertex( 0.26, 0.0, 0.26, 0.609863, 1.0),
	Vertex( 0.19, 2.41, -0.15, 0.649902, -1.569336),
	Vertex( -0.17, 2.55, -0.1, 1.0, -1.699219),
	Vertex( -0.0, 1.35, -0.38, 0.969727, -0.659668),
	Vertex( 0.33, 1.03, 0.0, 0.719727, -0.289795),
	Vertex( 0.34, 0.0, 0.0, 0.719727, 1.0),
	Vertex( 0.26, 0.0, -0.26, 0.849609, 1.0),
	Vertex( 0.0, 0.0, -0.34, 1.0, 1.0)
};
u16[] Rock_island_IDs = {0,1,2,3,0,2,4,3,2,3,5,0,6,3,4,7,5,3,6,8,3,8,7,3,6,9,8,9,10,8,11,7,8,11,12,7,12,11,13,10,14,8,14,11,8,11,14,13,10,15,14,14,15,16,14,16,13,16,17,13};

Vertex[] Rock_cross_Vertexes = 
{
	Vertex( 0.3, -0.0, 0.5, 0.0, 1.0),
	Vertex( 0.5, 2.5, 0.2, 0.389893, -1.5),
	Vertex( 0.2, 2.5, 0.5, 0.0, -1.5),
	Vertex( 0.5, 0.0, 0.3, 0.199951, 1.0),
	Vertex( 0.5, 0.0, -0.3, 0.0, 1.0),
	Vertex( 0.3, 0.0, -0.5, 0.199951, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.0, -1.5),
	Vertex( 0.2, 2.5, -0.5, 0.389893, -1.5),
	Vertex( -0.3, 0.0, -0.5, 1.0, 1.0),
	Vertex( -0.5, 2.5, -0.2, 0.599609, -1.5),
	Vertex( -0.2, 2.5, -0.5, 1.0, -1.5),
	Vertex( -0.5, -0.0, -0.3, 0.799805, 1.0),
	Vertex( -0.5, -0.0, 0.3, 0.799805, 1.0),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( -0.5, 2.5, 0.2, 0.599609, -1.5),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( 0.5, 2.5, -0.2, 0.009995, 0.339844),
	Vertex( 0.2, 2.5, -0.5, 0.029999, 0.709961),
	Vertex( -0.01, 2.72, -0.38, 0.279785, 0.72998),
	Vertex( -0.2, 2.5, -0.5, 0.299805, 0.97998),
	Vertex( 0.5, 2.5, 0.2, 0.25, 0.039978),
	Vertex( -0.5, 2.5, -0.2, 0.689941, 0.97998),
	Vertex( -0.28, 2.78, 0.17, 0.709961, 0.549805),
	Vertex( 0.2, 2.5, 0.5, 0.639648, 0.019989),
	Vertex( -0.5, 2.5, 0.2, 0.939941, 0.689941),
	Vertex( -0.2, 2.5, 0.5, 0.929688, 0.299805)
};
u16[] Rock_cross_IDs = {0,1,2,0,3,1,4,5,6,5,7,6,8,9,10,8,11,9,12,13,14,13,15,14,16,17,18,17,19,18,20,16,18,19,21,18,20,18,22,21,22,18,23,20,22,21,24,22,25,23,22,24,25,22};

Vertex[] Rock_bend_Vertexes = 
{
	Vertex( 0.5, 0.0, -0.3, 0.289795, 1.0),
	Vertex( 0.3, 0.0, -0.5, 0.089966, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.359863, -1.699219),
	Vertex( 0.2, 2.5, -0.5, 0.0, -1.699219),
	Vertex( 0.2, 2.5, -0.5, 0.769531, -1.699219),
	Vertex( -0.2, 2.5, -0.5, 1.0, -1.989258),
	Vertex( 0.04, 2.67, -0.34, 0.80957, -1.919922),
	Vertex( 0.5, 2.5, -0.2, 0.359863, -1.699219),
	Vertex( 0.5, 2.5, 0.2, 0.23999, -1.939453),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.3, -0.0, -0.25, 0.199951, 1.0),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.699219),
	Vertex( -0.11, -0.0, 0.05, 0.449951, 1.0),
	Vertex( 0.25, -0.0, 0.32, 0.799805, 1.0),
	Vertex( -0.01, 2.5, -0.1, 0.25, -1.699219),
	Vertex( 0.04, 2.67, -0.34, 0.22998, -2.0),
	Vertex( 0.5, 2.5, 0.2, 1.0, -1.699219),
	Vertex( 0.5, 0.0, 0.3, 1.0, 1.0)
};
u16[] Rock_bend_IDs = {0,1,2,1,3,2,4,5,6,7,4,6,8,7,6,9,10,11,10,12,11,12,13,11,13,14,11,11,14,15,14,16,15,13,16,14,13,17,16};

Vertex[] Rock_tee_Vertexes = 
{
	Vertex( 0.3, -0.0, 0.5, 0.72998, 1.0),
	Vertex( 0.5, 2.5, 0.2, 1.0, -1.5),
	Vertex( 0.2, 2.5, 0.5, 0.699707, -1.399414),
	Vertex( 0.5, 0.0, 0.3, 1.0, 1.0),
	Vertex( 0.5, 0.0, -0.3, 0.0, 1.0),
	Vertex( 0.3, 0.0, -0.5, 0.279785, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.0, -1.5),
	Vertex( 0.2, 2.5, -0.5, 0.299805, -1.399414),
	Vertex( -0.2, 2.5, 0.5, 0.899902, 0.899902),
	Vertex( 0.2, 2.5, 0.5, 1.0, 0.699707),
	Vertex( -0.28, 2.78, 0.17, 0.399902, 0.899902),
	Vertex( 0.5, 2.5, 0.2, 0.899902, 0.5),
	Vertex( -0.01, 2.72, -0.38, 0.299805, 0.5),
	Vertex( 0.5, 2.5, -0.2, 0.759766, 0.299805),
	Vertex( 0.2, 2.5, -0.5, 0.299805, 0.299805),
	Vertex( -0.2, 2.5, -0.5, 0.0, 0.5),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.4, 2.5, -0.05, 0.429932, -1.489258),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( -0.01, 2.72, -0.38, 0.119995, -1.959961),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( -0.28, 2.78, 0.17, 0.839844, -1.959961)
};
u16[] Rock_tee_IDs = {0,1,2,0,3,1,4,5,6,5,7,6,8,9,10,9,11,10,11,12,10,11,13,12,13,14,12,14,15,12,16,17,18,16,19,17,18,17,20,19,21,17,17,22,20,17,21,22};

Vertex[] Rock_choke_Vertexes = 
{
	Vertex( -0.5, -0.0, 0.3, 0.699707, 1.0),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( -0.5, 2.5, 0.2, 0.699707, -1.5),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( -0.3, 2.71, 0.14, 0.669922, -1.649414),
	Vertex( 0.5, 3.0, 0.5, 1.0, -2.0),
	Vertex( -0.5, 2.5, -0.2, 0.299805, -1.5),
	Vertex( -0.01, 2.67, -0.27, 0.199951, -1.699219),
	Vertex( 0.5, 3.0, -0.5, 0.0, -2.0),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.5, -0.0, -0.3, 0.299805, 1.0)
};
u16[] Rock_choke_IDs = {0,1,2,1,3,2,2,3,4,3,5,4,6,2,4,5,7,4,6,4,7,5,8,7,8,9,7,9,6,7,10,6,9,10,11,6};

Vertex[] Rock_split_Vertexes = 
{
	Vertex( 0.3, -0.0, 0.5, 0.799805, 1.0),
	Vertex( 0.5, 2.5, 0.3, 1.0, -1.5),
	Vertex( 0.2, 2.5, 0.5, 0.799805, -1.5),
	Vertex( 0.5, 0.0, 0.3, 1.0, 1.0),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.5, 2.5, -0.2, 0.25, -1.5),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
	Vertex( -0.5, -0.0, -0.3, 0.199951, 1.0),
	Vertex( -0.5, -0.0, 0.3, 0.399902, 1.0),
	Vertex( -0.3, -0.0, 0.5, 0.599609, 1.0),
	Vertex( -0.5, 2.5, 0.2, 0.419922, -1.5),
	Vertex( -0.2, 2.5, 0.5, 0.599609, -1.5),
	Vertex( 0.5, 3.0, -0.5, 0.439941, 0.099976),
	Vertex( -0.2, 2.5, -0.5, 0.109985, 0.55957),
	Vertex( -0.2, 2.84, 0.12, 0.47998, 0.699707),
	Vertex( 0.5, 2.5, 0.3, 0.919922, 0.519531),
	Vertex( -0.5, 2.5, -0.2, 0.149902, 0.80957),
	Vertex( 0.2, 2.5, 0.5, 0.899902, 0.739746),
	Vertex( -0.5, 2.5, 0.2, 0.389893, 0.959961),
	Vertex( -0.2, 2.5, 0.5, 0.719727, 0.929688)
};
u16[] Rock_split_IDs = {0,1,2,0,3,1,4,5,6,4,7,5,8,9,10,9,11,10,12,13,14,15,12,14,13,16,14,17,15,14,16,18,14,19,17,14,18,19,14};

Vertex[] Rock_panhandle_L_Vertexes = 
{
	Vertex( 0.3, -0.0, 0.5, 0.759766, 1.0),
	Vertex( 0.5, 0.0, 0.3, 1.0, 1.0),
	Vertex( 0.2, 2.5, 0.5, 0.699707, -1.5),
	Vertex( 0.5, 2.5, 0.2, 1.0, -1.5),
	Vertex( -0.31, 0.03, 0.25, 0.399902, 1.0),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( -0.24, 2.5, -0.11, 0.299805, -1.5),
	Vertex( -0.21, 0.03, -0.11, 0.199951, 1.0),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
	Vertex( 0.17, 2.86, 0.1, 0.589844, -1.759766),
	Vertex( 0.2, 2.5, 0.5, 1.0, -1.699219),
	Vertex( 0.5, 3.0, -0.5, 0.0, -2.0),
	Vertex( 0.5, 2.5, 0.2, 1.0, -2.0)
};
u16[] Rock_panhandle_L_IDs = {0,1,2,1,3,2,4,5,6,4,6,7,8,4,7,9,8,7,9,7,10,7,6,11,10,7,11,6,12,11,10,11,13,12,14,11,11,14,13};

Vertex[] Rock_panhandle_R_Vertexes = 
{
	Vertex( 0.3, 0.0, -0.5, 0.199951, 1.0),
	Vertex( 0.2, 2.5, -0.5, 0.199951, -1.5),
	Vertex( 0.5, 0.0, -0.3, 0.0, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.0, -1.5),
	Vertex( -0.31, 0.03, -0.25, 0.199951, 1.0),
	Vertex( -0.2, 2.5, -0.5, 0.0, -1.5),
	Vertex( -0.3, 0.0, -0.5, 0.0, 1.0),
	Vertex( -0.19, 2.5, 0.18, 0.799805, -1.5),
	Vertex( -0.21, 0.03, 0.11, 0.599609, 1.0),
	Vertex( -0.2, 2.5, 0.5, 1.0, -1.5),
	Vertex( -0.3, -0.0, 0.5, 1.0, 1.0),
	Vertex( 0.17, 2.86, -0.1, 0.439941, -1.759766),
	Vertex( 0.2, 2.5, -0.5, 0.0, -1.699219),
	Vertex( 0.5, 3.0, 0.5, 1.0, -2.0),
	Vertex( 0.5, 2.5, -0.2, 0.0, -2.0)
};
u16[] Rock_panhandle_R_IDs = {0,1,2,2,1,3,4,5,6,4,7,5,8,7,4,9,8,10,8,9,7,7,11,5,9,11,7,5,11,12,9,13,11,12,11,14,11,13,14};

Vertex[] Rock_diagonal_Vertexes = 
{
	Vertex( 0.5, 0.0, -0.3, 0.399902, 1.0),
	Vertex( 0.3, 0.0, -0.5, 0.649902, 1.0),
	Vertex( 0.5, 2.5, -0.2, 0.299805, -1.5),
	Vertex( 0.2, 2.5, -0.5, 0.699707, -1.5),
	Vertex( 0.14, 2.72, -0.18, 0.5, -1.769531),
	Vertex( 0.5, 3.0, 0.5, 0.0, -1.799805),
	Vertex( -0.5, 3.0, -0.5, 1.0, -1.799805),
	Vertex( -0.5, -0.0, 0.3, 0.399902, 1.0),
	Vertex( -0.3, -0.0, 0.5, 0.649902, 1.0),
	Vertex( -0.5, 2.5, 0.2, 0.299805, -1.5),
	Vertex( -0.2, 2.5, 0.5, 0.699707, -1.5),
	Vertex( -0.17, 2.78, 0.12, 0.5, -1.769531),
	Vertex( -0.5, 3.0, -0.5, 0.0, -1.799805),
	Vertex( 0.5, 3.0, 0.5, 1.0, -1.799805),
	Vertex( 0.14, 2.72, -0.18, 0.5, -2.0)
};
u16[] Rock_diagonal_IDs = {0,1,2,1,3,2,2,3,4,5,2,4,3,6,4,7,8,9,8,10,9,9,10,11,12,9,11,10,13,11,12,11,14,13,14,11};

Vertex[] flat_Vertexes = 
{
	Vertex(-0.5, 0, -0.5,   0.25, 0.0),
	Vertex(-0.5, 0,  0.5, 	0.5,  0.0),	
	Vertex( 0.5, 0,  0.5, 	0.5,  1.0),
	Vertex( 0.5, 0, -0.5, 	0.25, 1.0)
};
u16[] flat_IDs = {0,1,2,3,0,2};

Vertex[] flat_corner_Vertexes = 
{
	Vertex(-0.5, 0.15,    -0.5,    0.25, 0.0),
	Vertex(-0.5, 0.15,  0.5, 	0.5,  0.0),	
	Vertex( 0.5, 0.15,     0.5, 	0.5,  1.0),
	Vertex( 0.5, -0.15,    -0.5, 	0.25, 1.0)
};
u16[] flat_corner_IDs = {0,1,2,3,0,2};

//sand_shore_corner
//Rock_straight
//Rock_concave
//Rock_peninsula
//Rock_strip
//Rock_island
//Rock_cross
//Rock_bend
//Rock_Tee
//Rock_choke
//Rock_split
//Rock_panhandle_L
//Rock_panhandle_R
//Rock_diagonal		

Vertex[] Shark_Vertexes = 
{
	 Vertex( -0.042, -0.236, -1.106, 0.272461, 0.199219),
	 Vertex( -0.123, -0.2825, -1.263, 0.234741, 0.22937),
	 Vertex( 0.0, -0.191, -1.2635, 0.272461, 0.244019),
	 Vertex( 0.0, -0.379, 1.234, 0.085388, 0.009995),
	 Vertex( -0.138, -0.4205, 1.0235, 0.017883, 0.009995),
	 Vertex( 0.138, -0.4205, 1.0235, 0.057404, 0.071411),
	 Vertex( 0.123, -0.2825, -1.263, 0.363281, 0.384521),
	 Vertex( 0.0, -0.191, -1.2635, 0.37793, 0.34668),
	 Vertex( 0.042, -0.236, -1.106, 0.333252, 0.34668),
	 Vertex( 0.042, -0.236, -1.106, 0.385742, 0.353027),
	 Vertex( 0.0, -0.191, -1.2635, 0.369629, 0.394775),
	 Vertex( 0.123, -0.2825, -1.263, 0.410156, 0.394775),
	 Vertex( -0.123, -0.2825, -1.263, 0.047821, 0.09137),
	 Vertex( -0.042, -0.236, -1.106, 0.009995, 0.061249),
	 Vertex( 0.0, -0.191, -1.2635, 0.009995, 0.106018),
	 Vertex( -0.0, 0.752, -2.4315, 0.361816, 0.964355),
	 Vertex( -0.024, 0.4525, -2.1375, 0.250732, 0.95752),
	 Vertex( 0.024, 0.4525, -2.1375, 0.250732, 0.970215),
	 Vertex( -0.0225, 0.172, -1.9105, 0.155396, 0.95752),
	 Vertex( 0.0225, 0.172, -1.9105, 0.155396, 0.969238),
	 Vertex( -0.022964, 0.168452, -1.699121, 0.099121, 0.959473),
	 Vertex( 0.009231, 0.171567, -1.687629, 0.099121, 0.966797),
	 Vertex( 0.001836, 0.245985, -1.644253, 0.066589, 0.962891),
	 Vertex( -0.024, -0.381, -2.1495, 0.532227, 0.954102),
	 Vertex( 0.0, -0.5575, -2.395, 0.612305, 0.947754),
	 Vertex( 0.024, -0.381, -2.1495, 0.532227, 0.941406),
	 Vertex( -0.032, -0.271, -2.039, 0.491211, 0.956055),
	 Vertex( 0.032, -0.271, -2.039, 0.491211, 0.939453),
	 Vertex( -0.032, -0.0605, -1.9105, 0.425781, 0.956055),
	 Vertex( 0.032, -0.0605, -1.9105, 0.425781, 0.939453),
	 Vertex( 0.014, -0.062, -1.7585, 0.385742, 0.943848),
	 Vertex( -0.014, -0.062, -1.7585, 0.385742, 0.95166),
	 Vertex( 0.0, -0.178, -1.762, 0.35498, 0.947754),
	 Vertex( 0.138, -0.4205, 1.0235, 0.800293, 0.310059),
	 Vertex( 0.382, -0.3225, 0.289, 0.889648, 0.496094),
	 Vertex( 0.228, -0.19, 1.0995, 0.860352, 0.276855),
	 Vertex( 0.4075, -0.254, 0.2615, 0.910156, 0.498779),
	 Vertex( 0.2675, -0.0025, 1.0905, 0.910156, 0.266602),
	 Vertex( -0.0, 0.832, -0.4415, 0.862793, 0.686523),
	 Vertex( -0.0, 0.9735, -0.4395, 0.826172, 0.678223),
	 Vertex( 0.0165, 0.8605, -0.2835, 0.845703, 0.725586),
	 Vertex( -0.0, 0.6495, -0.4885, 0.912598, 0.686035),
	 Vertex( 0.03, 0.677, -0.1785, 0.885742, 0.764648),
	 Vertex( 0.034, 0.5235, -0.0835, 0.919434, 0.798828),
	 Vertex( -0.0, 0.454, -0.568, 0.968262, 0.678223),
	 Vertex( 0.0165, 0.8605, -0.2835, 0.549316, 0.160522),
	 Vertex( -0.0, 0.9735, -0.4395, 0.544922, 0.109619),
	 Vertex( -0.0165, 0.8605, -0.2835, 0.540527, 0.160522),
	 Vertex( 0.03, 0.677, -0.1785, 0.552734, 0.216553),
	 Vertex( -0.03, 0.677, -0.1785, 0.537109, 0.216553),
	 Vertex( 0.034, 0.5235, -0.0835, 0.554199, 0.26416),
	 Vertex( -0.034, 0.5235, -0.0835, 0.536133, 0.26416),
	 Vertex( 0.138, -0.4205, 1.0235, 0.449707, 0.728027),
	 Vertex( 0.228, -0.19, 1.0995, 0.382324, 0.714844),
	 Vertex( 0.0965, -0.2575, 1.2975, 0.382324, 0.779785),
	 Vertex( 0.0, -0.379, 1.234, 0.425293, 0.791016),
	 Vertex( 0.0, -0.2575, 1.329, 0.387695, 0.806152),
	 Vertex( 0.162, -0.2005, 1.163, 0.028137, 0.578613),
	 Vertex( 0.1975, -0.205, 1.0205, 0.009995, 0.613281),
	 Vertex( 0.1705, -0.159, 1.1715, 0.039032, 0.582031),
	 Vertex( 0.098, -0.1935, 1.3265, 0.048859, 0.537109),
	 Vertex( 0.098, -0.119, 1.361, 0.070557, 0.537598),
	 Vertex( 0.0, -0.1915, 1.381, 0.056, 0.508301),
	 Vertex( 0.0, -0.1065, 1.425, 0.081299, 0.508301),
	 Vertex( -0.098, -0.119, 1.361, 0.070557, 0.479248),
	 Vertex( -0.098, -0.1935, 1.3265, 0.048859, 0.479492),
	 Vertex( -0.1705, -0.159, 1.1715, 0.039032, 0.43457),
	 Vertex( -0.162, -0.2005, 1.163, 0.028137, 0.437988),
	 Vertex( -0.1975, -0.205, 1.0205, 0.009995, 0.403564),
	 Vertex( -0.196, -0.215, 1.072, 0.330078, 0.446533),
	 Vertex( -0.156, -0.2385, 1.187, 0.293701, 0.456055),
	 Vertex( -0.158, -0.1985, 1.21, 0.293213, 0.469971),
	 Vertex( -0.091, -0.2565, 1.2845, 0.258301, 0.463867),
	 Vertex( -0.093619, -0.198396, 1.297374, 0.259277, 0.480713),
	 Vertex( -0.001881, -0.2011, 1.334366, 0.22998, 0.485107),
	 Vertex( 0.0, -0.2615, 1.308, 0.22998, 0.467041),
	 Vertex( 0.091, -0.2565, 1.2845, 0.199951, 0.463867),
	 Vertex( 0.089878, -0.194391, 1.302318, 0.199829, 0.481689),
	 Vertex( 0.158, -0.1985, 1.21, 0.166748, 0.469971),
	 Vertex( 0.156, -0.2385, 1.187, 0.16626, 0.456055),
	 Vertex( 0.196, -0.215, 1.072, 0.129761, 0.446533),
	 Vertex( -0.1915, -0.4475, 0.3785, 0.722656, 0.839355),
	 Vertex( -0.138, -0.4205, 1.0235, 0.736816, 0.668457),
	 Vertex( -0.382, -0.3225, 0.289, 0.661621, 0.86084),
	 Vertex( 0.1915, -0.4475, 0.3785, 0.824219, 0.839355),
	 Vertex( 0.138, -0.4205, 1.0235, 0.810059, 0.668457),
	 Vertex( 0.382, -0.3225, 0.289, 0.885254, 0.86084),
	 Vertex( -0.138, -0.4205, 1.0235, 0.404297, 0.88916),
	 Vertex( -0.228, -0.19, 1.0995, 0.464355, 0.922363),
	 Vertex( -0.382, -0.3225, 0.289, 0.493408, 0.703125),
	 Vertex( -0.4075, -0.254, 0.2615, 0.513672, 0.700195),
	 Vertex( -0.2675, -0.0025, 1.0905, 0.513672, 0.932617),
	 Vertex( -0.75, -0.4425, 0.194, 0.74707, 0.884766),
	 Vertex( -0.901, -0.4955, 0.1005, 0.70459, 0.910156),
	 Vertex( -0.964, -0.5305, -0.0885, 0.686035, 0.959961),
	 Vertex( -0.546, -0.322, -0.029, 0.80957, 0.943848),
	 Vertex( -0.5205, -0.355, 0.2565, 0.811523, 0.867676),
	 Vertex( -0.382, -0.3225, 0.289, 0.849121, 0.85791),
	 Vertex( -0.409, -0.26, -0.092, 0.849609, 0.959961),
	 Vertex( -0.0, 0.832, -0.4415, 0.895508, 0.907227),
	 Vertex( -0.0165, 0.8605, -0.2835, 0.894043, 0.864258),
	 Vertex( -0.0, 0.9735, -0.4395, 0.858398, 0.901367),
	 Vertex( -0.0, 0.6495, -0.4885, 0.941406, 0.92627),
	 Vertex( -0.03, 0.677, -0.1785, 0.945801, 0.84375),
	 Vertex( -0.034, 0.5235, -0.0835, 0.989746, 0.824219),
	 Vertex( -0.0, 0.454, -0.568, 0.989746, 0.954102),
	 Vertex( -0.138, -0.4205, 1.0235, 0.078491, 0.820313),
	 Vertex( -0.0965, -0.2575, 1.2975, 0.022614, 0.756348),
	 Vertex( -0.228, -0.19, 1.0995, 0.009995, 0.820313),
	 Vertex( 0.0, -0.379, 1.234, 0.066895, 0.753906),
	 Vertex( 0.0, -0.2575, 1.329, 0.032837, 0.731445),
	 Vertex( -0.0, 0.1835, -1.577, 0.47998, 0.706055),
	 Vertex( -0.141, 0.3905, -0.5375, 0.200073, 0.664063),
	 Vertex( -0.0, 0.454, -0.568, 0.203613, 0.706055),
	 Vertex( -0.233, 0.0785, -0.872, 0.308838, 0.605469),
	 Vertex( -0.0615, 0.0365, -1.5285, 0.479736, 0.661621),
	 Vertex( 0.0, -0.0795, -1.635, 0.520508, 0.643555),
	 Vertex( 0.0, -0.191, -1.2635, 0.445313, 0.57373),
	 Vertex( -0.042, -0.236, -1.106, 0.408691, 0.547852),
	 Vertex( -0.042, -0.236, -1.106, 0.932617, 0.317627),
	 Vertex( 0.174, -0.3435, -0.5565, 0.989746, 0.169312),
	 Vertex( -0.174, -0.3435, -0.5565, 0.897461, 0.169312),
	 Vertex( 0.042, -0.236, -1.106, 0.95459, 0.317627),
	 Vertex( 0.0, -0.191, -1.2635, 0.943848, 0.36084),
	 Vertex( 0.1915, -0.4475, 0.3785, 0.359863, 0.339844),
	 Vertex( 0.409, -0.26, -0.092, 0.29248, 0.210327),
	 Vertex( 0.382, -0.3225, 0.289, 0.301025, 0.312256),
	 Vertex( 0.174, -0.3435, -0.5565, 0.364502, 0.09082),
	 Vertex( -0.1915, -0.4475, 0.3785, 0.461182, 0.339844),
	 Vertex( -0.174, -0.3435, -0.5565, 0.456543, 0.09082),
	 Vertex( -0.409, -0.26, -0.092, 0.52832, 0.210327),
	 Vertex( -0.382, -0.3225, 0.289, 0.519531, 0.312256),
	 Vertex( -0.0, 0.1835, -1.577, 0.734375, 0.009995),
	 Vertex( -0.0, 0.454, -0.568, 0.457764, 0.009995),
	 Vertex( 0.141, 0.3905, -0.5375, 0.454346, 0.051575),
	 Vertex( 0.233, 0.0785, -0.872, 0.562988, 0.110229),
	 Vertex( 0.0615, 0.0365, -1.5285, 0.733887, 0.054077),
	 Vertex( 0.0, -0.0795, -1.635, 0.774902, 0.072144),
	 Vertex( 0.0, -0.191, -1.2635, 0.699219, 0.141846),
	 Vertex( 0.042, -0.236, -1.106, 0.663086, 0.167847),
	 Vertex( 0.75, -0.4425, 0.194, 0.286377, 0.875),
	 Vertex( 0.964, -0.5305, -0.0885, 0.347168, 0.950195),
	 Vertex( 0.901, -0.4955, 0.1005, 0.328613, 0.899902),
	 Vertex( 0.546, -0.322, -0.029, 0.223511, 0.934082),
	 Vertex( 0.5205, -0.355, 0.2565, 0.221558, 0.85791),
	 Vertex( 0.382, -0.3225, 0.289, 0.184204, 0.847656),
	 Vertex( 0.409, -0.26, -0.092, 0.183594, 0.950195),
	 Vertex( 0.0, -0.117, -2.2335, 0.106995, 0.623535),
	 Vertex( 0.0, -0.5575, -2.395, 0.06604, 0.740723),
	 Vertex( -0.024, -0.381, -2.1495, 0.130737, 0.693359),
	 Vertex( -0.032, -0.271, -2.039, 0.159668, 0.663574),
	 Vertex( -0.032, -0.0605, -1.9105, 0.192749, 0.607422),
	 Vertex( -0.0, 0.206, -2.229, 0.107056, 0.538086),
	 Vertex( -0.024, 0.4525, -2.1375, 0.130737, 0.472412),
	 Vertex( -0.0, 0.752, -2.4315, 0.051392, 0.394287),
	 Vertex( -0.0225, 0.172, -1.9105, 0.19165, 0.545898),
	 Vertex( -0.022964, 0.168452, -1.699121, 0.243286, 0.548828),
	 Vertex( -0.014, -0.062, -1.7585, 0.233154, 0.606934),
	 Vertex( -0.0, 0.1835, -1.577, 0.275146, 0.541992),
	 Vertex( 0.001836, 0.245985, -1.644253, 0.25293, 0.525879),
	 Vertex( -0.0615, 0.0365, -1.5285, 0.294678, 0.57959),
	 Vertex( 0.0, -0.0795, -1.635, 0.265625, 0.61377),
	 Vertex( 0.0, -0.178, -1.762, 0.230713, 0.637695),
	 Vertex( -0.141, 0.3905, -0.5375, 0.828125, 0.632324),
	 Vertex( -0.034, 0.5235, -0.0835, 0.779297, 0.513672),
	 Vertex( -0.0, 0.454, -0.568, 0.787598, 0.643066),
	 Vertex( -0.25, 0.4195, 0.273, 0.837891, 0.416016),
	 Vertex( -0.0, 0.47, 0.273, 0.770508, 0.418213),
	 Vertex( 0.034, 0.5235, -0.0835, 0.76123, 0.513672),
	 Vertex( 0.25, 0.4195, 0.273, 0.703125, 0.416016),
	 Vertex( 0.141, 0.3905, -0.5375, 0.712891, 0.632324),
	 Vertex( -0.0, 0.454, -0.568, 0.753418, 0.643066),
	 Vertex( -0.12, -0.1165, 1.403, 0.844727, 0.18335),
	 Vertex( -0.228, -0.19, 1.0995, 0.744141, 0.18335),
	 Vertex( 0.0, -0.1745, 0.9975, 0.759766, 0.240234),
	 Vertex( 0.0, -0.1095, 1.444, 0.865723, 0.2146),
	 Vertex( 0.12, -0.1165, 1.403, 0.861328, 0.251709),
	 Vertex( 0.228, -0.19, 1.0995, 0.771484, 0.297852),
	 Vertex( -0.042, -0.236, -1.106, 0.393066, 0.047302),
	 Vertex( -0.174, -0.3435, -0.5565, 0.245117, 0.009995),
	 Vertex( -0.233, 0.0785, -0.872, 0.314697, 0.132202),
	 Vertex( -0.409, -0.26, -0.092, 0.106812, 0.031708),
	 Vertex( -0.3595, 0.1505, -0.238, 0.143188, 0.141602),
	 Vertex( -0.141, 0.3905, -0.5375, 0.228271, 0.221558),
	 Vertex( -0.388, 0.1625, 0.202, 0.026428, 0.143311),
	 Vertex( -0.25, 0.4195, 0.273, 0.009995, 0.221558),
	 Vertex( 0.0, -0.1745, 0.9975, 0.759766, 0.240234),
	 Vertex( -0.228, -0.19, 1.0995, 0.744141, 0.18335),
	 Vertex( -0.0965, -0.2575, 1.2975, 0.682129, 0.228882),
	 Vertex( 0.0, -0.2575, 1.329, 0.679199, 0.259521),
	 Vertex( 0.0965, -0.2575, 1.2975, 0.695801, 0.2854),
	 Vertex( 0.228, -0.19, 1.0995, 0.771484, 0.297852),
	 Vertex( 0.0, -0.117, -2.2335, 0.582031, 0.356201),
	 Vertex( 0.024, -0.381, -2.1495, 0.512207, 0.33374),
	 Vertex( 0.0, -0.5575, -2.395, 0.46582, 0.39917),
	 Vertex( 0.032, -0.271, -2.039, 0.541016, 0.304199),
	 Vertex( 0.032, -0.0605, -1.9105, 0.59668, 0.270264),
	 Vertex( -0.0, 0.206, -2.229, 0.66748, 0.354736),
	 Vertex( 0.024, 0.4525, -2.1375, 0.73291, 0.329834),
	 Vertex( -0.0, 0.752, -2.4315, 0.8125, 0.407959),
	 Vertex( 0.0225, 0.172, -1.9105, 0.658203, 0.270264),
	 Vertex( 0.009231, 0.171567, -1.687629, 0.658203, 0.2146),
	 Vertex( 0.014, -0.062, -1.7585, 0.59668, 0.229736),
	 Vertex( -0.0, 0.1835, -1.577, 0.664063, 0.184082),
	 Vertex( 0.001836, 0.245985, -1.644253, 0.680176, 0.204956),
	 Vertex( 0.0615, 0.0365, -1.5285, 0.622559, 0.167725),
	 Vertex( 0.0, -0.0795, -1.635, 0.589355, 0.197388),
	 Vertex( 0.0, -0.178, -1.762, 0.565918, 0.232788),
	 Vertex( 0.042, -0.236, -1.106, 0.383057, 0.424316),
	 Vertex( 0.233, 0.0785, -0.872, 0.309326, 0.335205),
	 Vertex( 0.174, -0.3435, -0.5565, 0.233276, 0.453613),
	 Vertex( 0.409, -0.26, -0.092, 0.096313, 0.424316),
	 Vertex( 0.3595, 0.1505, -0.238, 0.13855, 0.31665),
	 Vertex( 0.141, 0.3905, -0.5375, 0.227905, 0.241333),
	 Vertex( 0.388, 0.1625, 0.202, 0.022141, 0.30835),
	 Vertex( 0.25, 0.4195, 0.273, 0.009995, 0.229492),
	 Vertex( -0.2385, 0.33, 0.707, 0.256592, 0.714355),
	 Vertex( -0.0, 0.47, 0.273, 0.375244, 0.782227),
	 Vertex( -0.25, 0.4195, 0.273, 0.374023, 0.714355),
	 Vertex( 0.2385, 0.33, 0.707, 0.253906, 0.844727),
	 Vertex( 0.25, 0.4195, 0.273, 0.371338, 0.849609),
	 Vertex( -0.0, 0.3945, 0.707, 0.258789, 0.779785),
	 Vertex( -0.197, 0.205, 1.2635, 0.105286, 0.723145),
	 Vertex( 0.197, 0.205, 1.2635, 0.103027, 0.830078),
	 Vertex( -0.0, 0.24, 1.2935, 0.098694, 0.776367),
	 Vertex( -0.228, -0.19, 1.0995, 0.687988, 0.893555),
	 Vertex( -0.12, -0.1165, 1.403, 0.62207, 0.839355),
	 Vertex( -0.2675, -0.0025, 1.0905, 0.653809, 0.930664),
	 Vertex( -0.0, 0.03, 1.608, 0.552246, 0.813965),
	 Vertex( 0.0, -0.1095, 1.444, 0.608398, 0.808594),
	 Vertex( -0.076, 0.0875, 1.5955, 0.549316, 0.838379),
	 Vertex( -0.197, 0.205, 1.2635, 0.577148, 0.930664),
	 Vertex( -0.0, 0.113092, 1.625445, 0.530762, 0.823242),
	 Vertex( -0.0, 0.24, 1.2935, 0.521973, 0.923828),
	 Vertex( -0.4075, -0.254, 0.2615, 0.9375, 0.506836),
	 Vertex( -0.409, -0.26, -0.092, 0.844238, 0.510742),
	 Vertex( -0.546, -0.322, -0.029, 0.862793, 0.549316),
	 Vertex( -0.5165, -0.324, 0.1985, 0.923828, 0.542969),
	 Vertex( -0.382, -0.3225, 0.289, 0.956055, 0.51416),
	 Vertex( -0.5205, -0.355, 0.2565, 0.939941, 0.548828),
	 Vertex( -0.75, -0.4425, 0.194, 0.92041, 0.612305),
	 Vertex( -0.7665, -0.4235, 0.077, 0.88916, 0.613281),
	 Vertex( -0.964, -0.5305, -0.0885, 0.844238, 0.672363),
	 Vertex( -0.901, -0.4955, 0.1005, 0.894531, 0.653809),
	 Vertex( 0.228, -0.19, 1.0995, 0.819824, 0.009995),
	 Vertex( 0.2675, -0.0025, 1.0905, 0.782715, 0.04422),
	 Vertex( 0.12, -0.1165, 1.403, 0.874023, 0.075989),
	 Vertex( -0.0, 0.03, 1.608, 0.899414, 0.145874),
	 Vertex( 0.0, -0.1095, 1.444, 0.904785, 0.089661),
	 Vertex( 0.076, 0.0875, 1.5955, 0.875, 0.148682),
	 Vertex( 0.197, 0.205, 1.2635, 0.782715, 0.120667),
	 Vertex( -0.0, 0.113092, 1.625445, 0.889648, 0.167114),
	 Vertex( -0.0, 0.24, 1.2935, 0.789551, 0.175903),
	 Vertex( 0.4075, -0.254, 0.2615, 0.009995, 0.941406),
	 Vertex( 0.546, -0.322, -0.029, 0.052704, 0.866699),
	 Vertex( 0.409, -0.26, -0.092, 0.013969, 0.848145),
	 Vertex( 0.5165, -0.324, 0.1985, 0.046082, 0.927734),
	 Vertex( 0.382, -0.3225, 0.289, 0.017654, 0.959961),
	 Vertex( 0.5205, -0.355, 0.2565, 0.052277, 0.944336),
	 Vertex( 0.75, -0.4425, 0.194, 0.115662, 0.924316),
	 Vertex( 0.7665, -0.4235, 0.077, 0.11676, 0.893066),
	 Vertex( 0.964, -0.5305, -0.0885, 0.175415, 0.848145),
	 Vertex( 0.901, -0.4955, 0.1005, 0.157227, 0.898438),
	 Vertex( -0.2675, -0.0025, 1.0905, 0.337402, 0.450684),
	 Vertex( -0.197, 0.205, 1.2635, 0.290527, 0.507813),
	 Vertex( -0.377, 0.135, 0.6755, 0.45166, 0.483154),
	 Vertex( -0.4075, -0.254, 0.2615, 0.561035, 0.380615),
	 Vertex( -0.2385, 0.33, 0.707, 0.438232, 0.54541),
	 Vertex( -0.409, -0.26, -0.092, 0.654785, 0.380615),
	 Vertex( -0.25, 0.4195, 0.273, 0.553711, 0.569824),
	 Vertex( -0.388, 0.1625, 0.202, 0.57666, 0.493164),
	 Vertex( 0.4075, -0.254, 0.2615, 0.526367, 0.706055),
	 Vertex( 0.409, -0.26, -0.092, 0.526367, 0.799805),
	 Vertex( 0.377, 0.135, 0.6755, 0.628906, 0.59668),
	 Vertex( 0.388, 0.1625, 0.202, 0.638672, 0.72168),
	 Vertex( 0.2675, -0.0025, 1.0905, 0.596191, 0.482666),
	 Vertex( 0.25, 0.4195, 0.273, 0.71582, 0.69873),
	 Vertex( 0.197, 0.205, 1.2635, 0.653809, 0.435791),
	 Vertex( 0.2385, 0.33, 0.707, 0.690918, 0.583008)
};
u16[] Shark_IDs = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,17,16,17,18,19,20,19,18,19,20,21,20,22,21,23,24,25,26,23,25,25,27,26,28,26,27,27,29,28,30,28,29,28,30,31,32,31,30,33,34,35,35,34,36,35,36,37,38,39,40,40,41,38,40,42,41,43,41,42,41,43,44,45,46,47,47,48,45,48,47,49,49,50,48,50,49,51,52,53,54,55,52,54,56,55,54,57,58,59,60,57,59,59,61,60,61,62,60,62,61,63,64,62,63,62,64,65,64,66,65,65,66,67,67,66,68,69,70,71,72,71,70,72,73,71,72,74,73,74,72,75,76,74,75,74,76,77,76,78,77,76,79,78,80,78,79,81,82,83,82,81,84,84,85,82,84,86,85,87,88,89,88,90,89,88,91,90,92,93,94,92,94,95,96,92,95,97,96,95,98,97,95,99,100,101,102,100,99,100,102,103,102,104,103,104,102,105,106,107,108,107,106,109,110,107,109,111,112,113,112,111,114,111,115,114,115,116,114,116,117,114,118,114,117,119,120,121,120,119,122,122,119,123,124,125,126,127,125,124,127,124,128,128,129,127,129,128,130,128,131,130,132,133,134,134,135,132,132,135,136,136,135,137,137,135,138,139,138,135,140,141,142,140,143,141,144,143,140,145,143,144,146,143,145,147,148,149,147,149,150,147,150,151,151,152,147,153,154,152,155,153,152,152,151,155,156,155,151,156,151,157,158,159,156,158,156,160,156,157,160,157,161,160,157,162,161,163,164,165,163,166,164,166,167,164,167,168,164,169,168,167,170,168,169,170,171,168,172,173,174,175,172,174,175,174,176,176,174,177,178,179,180,180,179,181,180,181,182,183,180,182,182,181,184,185,183,182,185,182,184,186,187,188,189,186,188,190,186,189,186,190,191,192,193,194,192,195,193,192,196,195,197,196,192,198,197,199,200,197,198,196,197,200,201,196,200,201,202,196,203,201,204,203,205,201,201,205,202,202,205,206,202,206,207,208,209,210,209,211,210,209,212,211,213,212,209,212,214,211,215,212,213,215,214,212,216,217,218,217,219,220,217,216,221,219,217,221,222,221,216,221,223,219,221,222,224,223,221,224,225,226,227,228,226,229,226,230,227,226,228,230,230,231,227,230,228,232,230,233,231,233,230,232,234,235,236,234,236,237,238,234,237,239,238,237,240,239,237,236,241,237,237,241,240,236,242,241,243,240,241,242,243,241,244,245,246,247,248,246,246,245,249,246,249,247,249,245,250,249,251,247,252,249,250,249,252,251,253,254,255,253,256,254,257,256,253,258,256,257,258,259,256,254,256,260,260,256,259,254,260,261,262,260,259,261,260,262,263,264,265,263,265,266,264,267,265,266,265,268,265,267,269,265,270,268,265,269,270,271,272,273,273,272,274,275,271,273,273,274,276,275,273,277,273,276,278,277,273,278};

Vertex[] shark_bod_Vertexes = 
{
	 Vertex( 0.112, -0.324, 0.792, 0.739746, 0.259766),
	 Vertex( 0.188, -0.132, 0.856, 0.759766, 0.289795),
	 Vertex( 0.0, -0.12, 0.516, 0.80957, 0.22998),
	 Vertex( -0.112, -0.324, 0.792, 0.739746, 0.22998),
	 Vertex( -0.188, -0.132, 0.856, 0.739746, 0.199951),
	 Vertex( 0.156, -0.344, 0.264, 0.819824, 0.839844),
	 Vertex( 0.312, -0.244, 0.188, 0.889648, 0.859863),
	 Vertex( 0.112, -0.324, 0.792, 0.80957, 0.669922),
	 Vertex( -0.156, -0.344, 0.264, 0.719727, 0.839844),
	 Vertex( -0.112, -0.324, 0.792, 0.739746, 0.669922),
	 Vertex( -0.312, -0.244, 0.188, 0.659668, 0.859863),
	 Vertex( 0.132, -0.14, 0.908, 0.029999, 0.57959),
	 Vertex( 0.164, -0.144, 0.792, 0.009995, 0.609863),
	 Vertex( 0.14, -0.108, 0.916, 0.039978, 0.57959),
	 Vertex( 0.08, -0.136, 1.04, 0.049988, 0.539551),
	 Vertex( 0.08, -0.076, 1.072, 0.069946, 0.539551),
	 Vertex( 0.0, -0.136, 1.088, 0.059998, 0.509766),
	 Vertex( 0.0, -0.064, 1.124, 0.079956, 0.509766),
	 Vertex( -0.08, -0.076, 1.072, 0.069946, 0.47998),
	 Vertex( -0.08, -0.136, 1.04, 0.049988, 0.47998),
	 Vertex( -0.14, -0.108, 0.916, 0.039978, 0.429932),
	 Vertex( -0.132, -0.14, 0.908, 0.029999, 0.439941),
	 Vertex( -0.164, -0.144, 0.792, 0.009995, 0.399902),
	 Vertex( 0.012, 0.728, -0.28, 0.549805, 0.159912),
	 Vertex( -0.0, 0.824, -0.408, 0.549805, 0.109985),
	 Vertex( -0.012, 0.728, -0.28, 0.539551, 0.159912),
	 Vertex( 0.024, 0.58, -0.196, 0.549805, 0.219971),
	 Vertex( -0.024, 0.58, -0.196, 0.539551, 0.219971),
	 Vertex( -0.028, 0.452, -0.116, 0.539551, 0.259766),
	 Vertex( 0.028, 0.452, -0.116, 0.549805, 0.259766),
	 Vertex( -0.0, 0.708, -0.412, 0.859863, 0.689941),
	 Vertex( -0.0, 0.824, -0.408, 0.82959, 0.679688),
	 Vertex( 0.012, 0.728, -0.28, 0.849609, 0.72998),
	 Vertex( -0.0, 0.556, -0.448, 0.909668, 0.689941),
	 Vertex( 0.024, 0.58, -0.196, 0.889648, 0.759766),
	 Vertex( 0.028, 0.452, -0.116, 0.919922, 0.799805),
	 Vertex( -0.0, 0.396, -0.516, 0.969727, 0.679688),
	 Vertex( 0.112, -0.324, 0.792, 0.799805, 0.309814),
	 Vertex( 0.312, -0.244, 0.188, 0.889648, 0.5),
	 Vertex( 0.188, -0.132, 0.856, 0.859863, 0.279785),
	 Vertex( 0.336, -0.184, 0.168, 0.909668, 0.5),
	 Vertex( 0.22, 0.02, 0.848, 0.909668, 0.269775),
	 Vertex( -0.156, -0.344, 0.264, 0.459961, 0.339844),
	 Vertex( -0.312, -0.244, 0.188, 0.519531, 0.309814),
	 Vertex( -0.336, -0.192, -0.124, 0.529785, 0.209961),
	 Vertex( -0.144, -0.26, -0.504, 0.459961, 0.089966),
	 Vertex( 0.156, -0.344, 0.264, 0.359863, 0.339844),
	 Vertex( 0.144, -0.26, -0.504, 0.359863, 0.089966),
	 Vertex( 0.336, -0.192, -0.124, 0.289795, 0.209961),
	 Vertex( 0.312, -0.244, 0.188, 0.299805, 0.309814),
	 Vertex( -0.0, 0.708, -0.412, 0.899902, 0.909668),
	 Vertex( -0.012, 0.728, -0.28, 0.889648, 0.859863),
	 Vertex( -0.0, 0.824, -0.408, 0.859863, 0.899902),
	 Vertex( -0.0, 0.556, -0.448, 0.939941, 0.929688),
	 Vertex( -0.024, 0.58, -0.196, 0.949707, 0.839844),
	 Vertex( -0.028, 0.452, -0.116, 0.989746, 0.819824),
	 Vertex( -0.0, 0.396, -0.516, 0.989746, 0.949707),
	 Vertex( -0.616, -0.34, 0.112, 0.75, 0.889648),
	 Vertex( -0.74, -0.384, 0.036, 0.699707, 0.909668),
	 Vertex( -0.792, -0.412, -0.12, 0.689941, 0.959961),
	 Vertex( -0.448, -0.24, -0.072, 0.80957, 0.939941),
	 Vertex( -0.428, -0.268, 0.164, 0.80957, 0.869629),
	 Vertex( -0.312, -0.244, 0.188, 0.849609, 0.859863),
	 Vertex( -0.336, -0.192, -0.124, 0.849609, 0.959961),
	 Vertex( 0.616, -0.34, 0.112, 0.289795, 0.879883),
	 Vertex( 0.792, -0.412, -0.12, 0.349854, 0.949707),
	 Vertex( 0.74, -0.384, 0.036, 0.329834, 0.899902),
	 Vertex( 0.448, -0.24, -0.072, 0.219971, 0.929688),
	 Vertex( 0.428, -0.268, 0.164, 0.219971, 0.859863),
	 Vertex( 0.312, -0.244, 0.188, 0.179932, 0.849609),
	 Vertex( 0.336, -0.192, -0.124, 0.179932, 0.949707),
	 Vertex( -0.112, -0.324, 0.792, 0.399902, 0.889648),
	 Vertex( -0.188, -0.132, 0.856, 0.459961, 0.919922),
	 Vertex( -0.312, -0.244, 0.188, 0.48999, 0.699707),
	 Vertex( -0.336, -0.184, 0.168, 0.509766, 0.699707),
	 Vertex( -0.22, 0.02, 0.848, 0.509766, 0.929688),
	 Vertex( -0.1, -0.072, 1.104, 0.839844, 0.179932),
	 Vertex( -0.188, -0.132, 0.856, 0.739746, 0.179932),
	 Vertex( 0.0, -0.12, 0.516, 0.709961, 0.25),
	 Vertex( 0.0, -0.068, 1.14, 0.869629, 0.209961),
	 Vertex( 0.1, -0.072, 1.104, 0.859863, 0.25),
	 Vertex( 0.188, -0.132, 0.856, 0.769531, 0.299805),
	 Vertex( -0.116, 0.344, -0.488, 0.82959, 0.629883),
	 Vertex( -0.028, 0.452, -0.116, 0.779785, 0.509766),
	 Vertex( -0.0, 0.396, -0.516, 0.789551, 0.639648),
	 Vertex( -0.204, 0.368, 0.176, 0.839844, 0.419922),
	 Vertex( -0.0, 0.408, 0.176, 0.769531, 0.419922),
	 Vertex( 0.028, 0.452, -0.116, 0.759766, 0.509766),
	 Vertex( 0.204, 0.368, 0.176, 0.699707, 0.419922),
	 Vertex( 0.116, 0.344, -0.488, 0.709961, 0.629883),
	 Vertex( -0.0, 0.396, -0.516, 0.75, 0.639648),
	 Vertex( -0.336, -0.184, 0.168, 0.939941, 0.509766),
	 Vertex( -0.336, -0.192, -0.124, 0.839844, 0.509766),
	 Vertex( -0.448, -0.24, -0.072, 0.859863, 0.549805),
	 Vertex( -0.424, -0.244, 0.116, 0.919922, 0.539551),
	 Vertex( -0.312, -0.244, 0.188, 0.959961, 0.509766),
	 Vertex( -0.428, -0.268, 0.164, 0.939941, 0.549805),
	 Vertex( -0.616, -0.34, 0.112, 0.919922, 0.609863),
	 Vertex( -0.628, -0.324, 0.016, 0.889648, 0.609863),
	 Vertex( -0.792, -0.412, -0.12, 0.839844, 0.669922),
	 Vertex( -0.74, -0.384, 0.036, 0.889648, 0.649902),
	 Vertex( 0.336, -0.184, 0.168, 0.009995, 0.939941),
	 Vertex( 0.448, -0.24, -0.072, 0.049988, 0.869629),
	 Vertex( 0.336, -0.192, -0.124, 0.009995, 0.849609),
	 Vertex( 0.424, -0.244, 0.116, 0.049988, 0.929688),
	 Vertex( 0.312, -0.244, 0.188, 0.019989, 0.959961),
	 Vertex( 0.428, -0.268, 0.164, 0.049988, 0.939941),
	 Vertex( 0.616, -0.34, 0.112, 0.119995, 0.919922),
	 Vertex( 0.628, -0.324, 0.016, 0.119995, 0.889648),
	 Vertex( 0.792, -0.412, -0.12, 0.179932, 0.849609),
	 Vertex( 0.74, -0.384, 0.036, 0.159912, 0.899902),
	 Vertex( -0.0, 0.048, 1.272, 0.899902, 0.149902),
	 Vertex( 0.0, -0.068, 1.14, 0.909668, 0.089966),
	 Vertex( 0.1, -0.072, 1.104, 0.869629, 0.079956),
	 Vertex( 0.188, -0.132, 0.856, 0.819824, 0.009995),
	 Vertex( 0.22, 0.02, 0.848, 0.779785, 0.039978),
	 Vertex( 0.064, 0.096, 1.264, 0.879883, 0.149902),
	 Vertex( -0.0, 0.116, 1.288, 0.889648, 0.169922),
	 Vertex( 0.16, 0.192, 0.988, 0.779785, 0.119995),
	 Vertex( -0.0, 0.22, 1.016, 0.789551, 0.179932),
	 Vertex( -0.188, -0.132, 0.856, 0.689941, 0.889648),
	 Vertex( -0.1, -0.072, 1.104, 0.619629, 0.839844),
	 Vertex( -0.22, 0.02, 0.848, 0.649902, 0.929688),
	 Vertex( -0.0, 0.048, 1.272, 0.549805, 0.80957),
	 Vertex( 0.0, -0.068, 1.14, 0.609863, 0.80957),
	 Vertex( -0.064, 0.096, 1.264, 0.549805, 0.839844),
	 Vertex( -0.16, 0.192, 0.988, 0.57959, 0.929688),
	 Vertex( -0.0, 0.116, 1.288, 0.529785, 0.819824),
	 Vertex( -0.0, 0.22, 1.016, 0.519531, 0.919922),
	 Vertex( -0.196, 0.292, 0.532, 0.259766, 0.709961),
	 Vertex( -0.0, 0.408, 0.176, 0.379883, 0.779785),
	 Vertex( -0.204, 0.368, 0.176, 0.369873, 0.709961),
	 Vertex( 0.196, 0.292, 0.532, 0.25, 0.849609),
	 Vertex( 0.204, 0.368, 0.176, 0.369873, 0.849609),
	 Vertex( -0.0, 0.348, 0.532, 0.259766, 0.779785),
	 Vertex( -0.16, 0.192, 0.988, 0.109985, 0.719727),
	 Vertex( 0.16, 0.192, 0.988, 0.099976, 0.82959),
	 Vertex( -0.0, 0.22, 1.016, 0.099976, 0.779785),
	 Vertex( -0.296, 0.148, -0.244, 0.139893, 0.139893),
	 Vertex( -0.336, -0.192, -0.124, 0.109985, 0.029999),
	 Vertex( -0.32, 0.156, 0.116, 0.029999, 0.139893),
	 Vertex( -0.144, -0.26, -0.504, 0.25, 0.009995),
	 Vertex( -0.204, 0.368, 0.176, 0.009995, 0.219971),
	 Vertex( -0.192, 0.088, -0.548, 0.309814, 0.129883),
	 Vertex( -0.116, 0.344, -0.488, 0.22998, 0.219971),
	 Vertex( 0.296, 0.148, -0.244, 0.139893, 0.319824),
	 Vertex( 0.32, 0.156, 0.116, 0.019989, 0.309814),
	 Vertex( 0.336, -0.192, -0.124, 0.099976, 0.419922),
	 Vertex( 0.144, -0.26, -0.504, 0.22998, 0.449951),
	 Vertex( 0.204, 0.368, 0.176, 0.009995, 0.22998),
	 Vertex( 0.192, 0.088, -0.548, 0.309814, 0.339844),
	 Vertex( 0.116, 0.344, -0.488, 0.22998, 0.23999),
	 Vertex( -0.192, 0.088, -0.548, 0.279785, 0.349854),
	 Vertex( -0.116, 0.344, -0.488, 0.259766, 0.289795),
	 Vertex( -0.0, 0.092, -0.68, 0.219971, 0.349854),
	 Vertex( -0.144, -0.26, -0.504, 0.259766, 0.439941),
	 Vertex( -0.0, 0.396, -0.516, 0.219971, 0.269775),
	 Vertex( 0.144, -0.26, -0.504, 0.179932, 0.439941),
	 Vertex( 0.116, 0.344, -0.488, 0.179932, 0.289795),
	 Vertex( 0.192, 0.088, -0.548, 0.159912, 0.359863),
	 Vertex( -0.16, 0.192, 0.988, 0.289795, 0.509766),
	 Vertex( -0.196, 0.292, 0.532, 0.439941, 0.549805),
	 Vertex( -0.308, 0.132, 0.508, 0.449951, 0.47998),
	 Vertex( -0.204, 0.368, 0.176, 0.549805, 0.569824),
	 Vertex( -0.22, 0.02, 0.848, 0.339844, 0.449951),
	 Vertex( -0.32, 0.156, 0.116, 0.57959, 0.48999),
	 Vertex( -0.336, -0.184, 0.168, 0.55957, 0.379883),
	 Vertex( -0.336, -0.192, -0.124, 0.649902, 0.379883),
	 Vertex( 0.22, 0.02, 0.848, 0.599609, 0.47998),
	 Vertex( 0.336, -0.184, 0.168, 0.529785, 0.709961),
	 Vertex( 0.308, 0.132, 0.508, 0.629883, 0.599609),
	 Vertex( 0.16, 0.192, 0.988, 0.649902, 0.439941),
	 Vertex( 0.336, -0.192, -0.124, 0.529785, 0.799805),
	 Vertex( 0.196, 0.292, 0.532, 0.689941, 0.57959),
	 Vertex( 0.32, 0.156, 0.116, 0.639648, 0.719727),
	 Vertex( 0.204, 0.368, 0.176, 0.719727, 0.699707)
};
u16[] shark_bod_IDs = {0,1,2,3,0,2,3,2,4,5,6,7,7,8,5,9,8,7,8,9,10,11,12,13,14,11,13,13,15,14,15,16,14,15,17,16,17,18,16,18,19,16,18,20,19,19,20,21,21,20,22,23,24,25,25,26,23,26,25,27,28,26,27,26,28,29,30,31,32,32,33,30,32,34,33,35,33,34,35,36,33,37,38,39,39,38,40,39,40,41,42,43,44,45,42,44,42,45,46,46,45,47,47,48,46,46,48,49,50,51,52,53,51,50,51,53,54,53,55,54,56,55,53,57,58,59,57,59,60,61,57,60,62,61,60,63,62,60,64,65,66,64,67,65,68,67,64,69,67,68,70,67,69,71,72,73,72,74,73,72,75,74,76,77,78,79,76,78,79,78,80,80,78,81,82,83,84,82,85,83,85,86,83,86,87,83,88,87,86,89,87,88,89,90,87,91,92,93,91,93,94,95,91,94,96,95,94,97,96,94,93,98,94,94,98,97,93,99,98,100,97,98,99,100,98,101,102,103,101,104,102,105,104,101,106,104,105,106,107,104,102,104,108,108,104,107,102,108,109,110,108,107,109,108,110,111,112,113,114,115,113,113,116,111,113,115,116,116,117,111,116,115,118,116,119,117,119,116,118,120,121,122,123,121,124,121,125,122,121,123,125,125,126,122,125,123,127,125,128,126,127,128,125,129,130,131,130,132,133,130,129,134,132,130,134,135,134,129,134,136,132,137,134,135,136,134,137,138,139,140,141,139,138,142,138,140,143,141,138,142,144,138,144,143,138,145,146,147,145,147,148,149,146,145,150,145,148,149,145,151,151,145,150,152,153,154,155,152,154,153,156,154,157,155,154,156,158,154,159,157,154,158,159,154,160,161,162,162,161,163,164,160,162,162,163,165,164,162,166,162,165,167,166,162,167,168,169,170,168,170,171,169,172,170,171,170,173,170,172,174,170,175,173,170,174,175};

Vertex[] shark_jaw_Vertexes = 
{
	Vertex( 0.0, -0.082, 0.252, 0.089966, 0.009995),
	Vertex( -0.112, -0.114, 0.076, 0.019989, 0.009995),
	Vertex( 0.112, -0.114, 0.076, 0.059998, 0.069946),
	Vertex( 0.112, -0.114, 0.076, 0.799805, 0.309814),
	Vertex( 0.184, 0.086, -0.216, 0.889648, 0.5),
	Vertex( 0.188, 0.074, 0.14, 0.859863, 0.279785),
	Vertex( -0.112, -0.114, 0.076, 0.399902, 0.889648),
	Vertex( -0.188, 0.074, 0.14, 0.459961, 0.919922),
	Vertex( -0.184, 0.086, -0.216, 0.48999, 0.699707),
	Vertex( 0.156, -0.13, -0.452, 0.819824, 0.839844),
	Vertex( 0.184, 0.086, -0.216, 0.889648, 0.859863),
	Vertex( 0.112, -0.114, 0.076, 0.80957, 0.669922),
	Vertex( -0.156, -0.13, -0.452, 0.719727, 0.839844),
	Vertex( -0.112, -0.114, 0.076, 0.739746, 0.669922),
	Vertex( -0.184, 0.086, -0.216, 0.659668, 0.859863),
	Vertex( -0.16, 0.054, 0.116, 0.329834, 0.449951),
	Vertex( -0.128, 0.034, 0.212, 0.289795, 0.459961),
	Vertex( -0.128, 0.07, 0.232, 0.289795, 0.469971),
	Vertex( -0.076, 0.022, 0.292, 0.259766, 0.459961),
	Vertex( -0.076, 0.07, 0.304, 0.259766, 0.47998),
	Vertex( 0.0, 0.066, 0.332, 0.22998, 0.48999),
	Vertex( 0.0, 0.018, 0.312, 0.22998, 0.469971),
	Vertex( 0.076, 0.022, 0.292, 0.199951, 0.459961),
	Vertex( 0.072, 0.07, 0.308, 0.199951, 0.47998),
	Vertex( 0.128, 0.07, 0.232, 0.169922, 0.469971),
	Vertex( 0.128, 0.034, 0.212, 0.169922, 0.459961),
	Vertex( 0.16, 0.054, 0.116, 0.129883, 0.449951),
	Vertex( 0.0, 0.018, 0.328, 0.389893, 0.80957),
	Vertex( 0.0, -0.082, 0.252, 0.429932, 0.789551),
	Vertex( 0.08, 0.018, 0.304, 0.379883, 0.779785),
	Vertex( 0.112, -0.114, 0.076, 0.449951, 0.72998),
	Vertex( 0.188, 0.074, 0.14, 0.379883, 0.709961),
	Vertex( 0.0, 0.018, 0.328, 0.029999, 0.72998),
	Vertex( -0.08, 0.018, 0.304, 0.019989, 0.759766),
	Vertex( 0.0, -0.082, 0.252, 0.069946, 0.75),
	Vertex( -0.112, -0.114, 0.076, 0.079956, 0.819824),
	Vertex( -0.188, 0.074, 0.14, 0.009995, 0.819824),
	Vertex( -0.184, 0.086, -0.216, 0.819824, 0.189941),
	Vertex( -0.188, 0.074, 0.14, 0.739746, 0.189941),
	Vertex( 0.0, 0.078, -0.08, 0.789551, 0.22998),
	Vertex( 0.184, 0.086, -0.216, 0.839844, 0.259766),
	Vertex( -0.08, 0.018, 0.304, 0.689941, 0.22998),
	Vertex( 0.188, 0.074, 0.14, 0.769531, 0.289795),
	Vertex( 0.0, 0.018, 0.328, 0.679688, 0.259766),
	Vertex( 0.08, 0.018, 0.304, 0.699707, 0.279785)
};
u16[] shark_jaw_IDs = {0,1,2,3,4,5,6,7,8,9,10,11,11,12,9,13,12,11,12,13,14,15,16,17,18,17,16,18,19,17,18,20,19,20,18,21,22,20,21,20,22,23,22,24,23,22,25,24,26,24,25,27,28,29,28,30,29,30,31,29,32,33,34,33,35,34,35,33,36,37,38,39,37,39,40,39,38,41,39,42,40,43,39,41,39,44,42,44,39,43};

Vertex[] shark_tail_Vertexes = 
{
	Vertex( 0.036, -0.172, -0.456, 0.389893, 0.349854),
	Vertex( 0.1, -0.208, -0.588, 0.409912, 0.389893),
	Vertex( 0.0, -0.136, -0.588, 0.369873, 0.389893),
	Vertex( -0.1, -0.208, -0.588, 0.049988, 0.089966),
	Vertex( -0.036, -0.172, -0.456, 0.009995, 0.059998),
	Vertex( 0.0, -0.136, -0.588, 0.009995, 0.109985),
	Vertex( -0.036, -0.172, -0.456, 0.389893, 0.049988),
	Vertex( -0.144, -0.26, -0.008, 0.25, 0.009995),
	Vertex( -0.192, 0.088, -0.048, 0.309814, 0.129883),
	Vertex( 0.036, -0.172, -0.456, 0.379883, 0.419922),
	Vertex( 0.192, 0.088, -0.048, 0.309814, 0.339844),
	Vertex( 0.144, -0.26, -0.008, 0.22998, 0.449951),
	Vertex( -0.0, 0.64, -1.548, 0.359863, 0.959961),
	Vertex( -0.02, 0.396, -1.304, 0.25, 0.959961),
	Vertex( 0.02, 0.396, -1.304, 0.25, 0.969727),
	Vertex( -0.02, 0.164, -1.12, 0.159912, 0.959961),
	Vertex( 0.02, 0.164, -1.12, 0.159912, 0.969727),
	Vertex( -0.02, 0.16, -0.944, 0.099976, 0.959961),
	Vertex( 0.008, 0.164, -0.936, 0.099976, 0.969727),
	Vertex( -0.0, 0.224, -0.9, 0.069946, 0.959961),
	Vertex( -0.02, -0.292, -1.316, 0.529785, 0.949707),
	Vertex( 0.0, -0.436, -1.516, 0.609863, 0.949707),
	Vertex( 0.02, -0.292, -1.316, 0.529785, 0.939941),
	Vertex( 0.028, -0.2, -1.224, 0.48999, 0.939941),
	Vertex( -0.028, -0.2, -1.224, 0.48999, 0.959961),
	Vertex( 0.028, -0.028, -1.12, 0.429932, 0.939941),
	Vertex( -0.028, -0.028, -1.12, 0.429932, 0.959961),
	Vertex( -0.012, -0.028, -0.992, 0.389893, 0.949707),
	Vertex( 0.012, -0.028, -0.992, 0.389893, 0.939941),
	Vertex( 0.0, -0.124, -0.996, 0.359863, 0.949707),
	Vertex( -0.0, 0.172, -0.844, 0.72998, 0.009995),
	Vertex( -0.0, 0.396, -0.016, 0.459961, 0.009995),
	Vertex( 0.116, 0.344, 0.008, 0.449951, 0.049988),
	Vertex( 0.192, 0.088, -0.048, 0.55957, 0.109985),
	Vertex( 0.052, 0.052, -0.804, 0.72998, 0.049988),
	Vertex( 0.0, -0.044, -0.892, 0.779785, 0.069946),
	Vertex( 0.0, -0.136, -0.588, 0.699707, 0.139893),
	Vertex( 0.036, -0.172, -0.456, 0.659668, 0.169922),
	Vertex( -0.144, -0.26, -0.008, 0.899902, 0.169922),
	Vertex( -0.036, -0.172, -0.456, 0.929688, 0.319824),
	Vertex( 0.144, -0.26, -0.008, 0.989746, 0.169922),
	Vertex( 0.036, -0.172, -0.456, 0.959961, 0.319824),
	Vertex( 0.0, -0.136, -0.588, 0.939941, 0.359863),
	Vertex( -0.0, 0.172, -0.844, 0.47998, 0.709961),
	Vertex( -0.116, 0.344, 0.008, 0.199951, 0.659668),
	Vertex( -0.0, 0.396, -0.016, 0.199951, 0.709961),
	Vertex( -0.192, 0.088, -0.048, 0.309814, 0.609863),
	Vertex( -0.052, 0.052, -0.804, 0.47998, 0.659668),
	Vertex( 0.0, -0.044, -0.892, 0.519531, 0.639648),
	Vertex( 0.0, -0.136, -0.588, 0.449951, 0.569824),
	Vertex( -0.036, -0.172, -0.456, 0.409912, 0.549805),
	Vertex( 0.0, -0.072, -1.384, 0.57959, 0.359863),
	Vertex( 0.02, -0.292, -1.316, 0.509766, 0.329834),
	Vertex( 0.0, -0.436, -1.516, 0.469971, 0.399902),
	Vertex( 0.028, -0.2, -1.224, 0.539551, 0.299805),
	Vertex( 0.028, -0.028, -1.12, 0.599609, 0.269775),
	Vertex( -0.0, 0.192, -1.38, 0.669922, 0.349854),
	Vertex( 0.02, 0.396, -1.304, 0.72998, 0.329834),
	Vertex( -0.0, 0.64, -1.548, 0.80957, 0.409912),
	Vertex( 0.02, 0.164, -1.12, 0.659668, 0.269775),
	Vertex( 0.008, 0.164, -0.936, 0.659668, 0.209961),
	Vertex( 0.012, -0.028, -0.992, 0.599609, 0.22998),
	Vertex( -0.0, 0.172, -0.844, 0.659668, 0.179932),
	Vertex( -0.0, 0.224, -0.9, 0.679688, 0.199951),
	Vertex( 0.052, 0.052, -0.804, 0.619629, 0.169922),
	Vertex( 0.0, -0.044, -0.892, 0.589844, 0.199951),
	Vertex( 0.0, -0.124, -0.996, 0.569824, 0.22998),
	Vertex( 0.0, -0.072, -1.384, 0.109985, 0.619629),
	Vertex( 0.0, -0.436, -1.516, 0.069946, 0.739746),
	Vertex( -0.02, -0.292, -1.316, 0.129883, 0.689941),
	Vertex( -0.028, -0.2, -1.224, 0.159912, 0.659668),
	Vertex( -0.028, -0.028, -1.12, 0.189941, 0.609863),
	Vertex( -0.0, 0.192, -1.38, 0.109985, 0.539551),
	Vertex( -0.02, 0.396, -1.304, 0.129883, 0.469971),
	Vertex( -0.0, 0.64, -1.548, 0.049988, 0.389893),
	Vertex( -0.02, 0.164, -1.12, 0.189941, 0.549805),
	Vertex( -0.02, 0.16, -0.944, 0.23999, 0.549805),
	Vertex( -0.012, -0.028, -0.992, 0.22998, 0.609863),
	Vertex( -0.0, 0.172, -0.844, 0.279785, 0.539551),
	Vertex( -0.0, 0.224, -0.9, 0.25, 0.529785),
	Vertex( -0.052, 0.052, -0.804, 0.289795, 0.57959),
	Vertex( 0.0, -0.044, -0.892, 0.269775, 0.609863),
	Vertex( 0.0, -0.124, -0.996, 0.22998, 0.639648),
	Vertex( -0.116, 0.344, 0.008, 0.169922, 0.279785),
	Vertex( -0.192, 0.088, -0.048, 0.129883, 0.349854),
	Vertex( -0.0, 0.092, 0.296, 0.209961, 0.349854),
	Vertex( -0.0, 0.396, -0.016, 0.209961, 0.259766),
	Vertex( -0.144, -0.26, -0.008, 0.169922, 0.439941),
	Vertex( 0.116, 0.344, 0.008, 0.259766, 0.279785),
	Vertex( 0.144, -0.26, -0.008, 0.25, 0.439941),
	Vertex( 0.192, 0.088, -0.048, 0.289795, 0.349854)
};
u16[] shark_tail_IDs = {0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,13,15,14,14,15,16,17,16,15,18,16,17,17,19,18,20,21,22,23,20,22,24,20,23,25,24,23,26,24,25,27,26,25,25,28,27,29,27,28,30,31,32,32,33,30,30,33,34,34,33,35,35,33,36,37,36,33,38,39,40,40,39,41,41,39,42,43,44,45,44,43,46,43,47,46,47,48,46,48,49,46,50,46,49,51,52,53,51,54,52,51,55,54,55,51,56,57,56,58,59,56,57,59,55,56,60,55,59,60,61,55,62,60,63,62,64,60,60,64,61,61,64,65,61,65,66,67,68,69,67,69,70,67,70,71,72,67,71,73,74,72,75,73,72,71,75,72,76,75,71,76,71,77,78,79,76,78,76,80,76,77,80,77,81,80,77,82,81,83,84,85,86,83,85,84,87,85,88,86,85,87,89,85,90,88,85,89,90,85};
