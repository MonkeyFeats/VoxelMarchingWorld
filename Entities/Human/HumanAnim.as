#include "Human.as"
#include "HumanCommon.as"

Random _punchr(0xfecc);

void onTick( CSprite@ this )
{
	CBlob@ blob = this.getBlob();

	const bool solidGround = blob.isOnGround();

	if (blob.isAttached())
	{
		this.SetAnimation("default");
	}
	else if(solidGround)
	{	

		if (this.isAnimationEnded())
			//!(this.isAnimation("punch1") || this.isAnimation("punch2") || this.isAnimation("shoot")) )
		{
			if (blob.isKeyPressed( key_action2 ) && (blob.get_string( "current tool" ) == "pistol") && canShootPistol( blob ) && !blob.isKeyPressed( key_action1 ))
			{
				this.SetAnimation("shoot");
			}
			else if (blob.isKeyPressed( key_action2 ) && (blob.get_string( "current tool" ) == "deconstructor") && !blob.isKeyPressed( key_action1 ))
			{
				this.SetAnimation("reclaimloop");
				//this.animation.frame = 1;
			}
			else if (blob.isKeyPressed( key_action1 ) && (blob.get_string( "current tool" ) == "reconstructor") && !blob.isKeyPressed( key_action2 ))
			{
				//this.animation.frame = 1;
				this.SetAnimation("repairloop");
			}
			else if ((blob.get_string( "current tool" ) == "telescope") && blob.isKeyPressed( key_action2 ))
			{
				this.SetAnimation("scopein");
			}	
			else if ((blob.get_string( "current tool" ) == "telescope") && !blob.isKeyPressed( key_action2 ))
			{
				this.SetAnimation("scopeout");
			}		
			else if ( (blob.isKeyPressed( key_action1 ) || blob.isKeyPressed( key_action2 )) && (blob.get_string( "current tool" ) == "fists") )
			{
				this.SetAnimation("punch");
			}
			else if (blob.getShape().vellen > 0.1f) {
				this.SetAnimation("walk");
			}
			else {
				this.animation.frame = 0;
				this.SetAnimation("default");
			}
		}
	}
	else //in water
	{
		if (this.isAnimationEnded() ||
			!(this.isAnimation("shoot")) )
		{
			if (blob.isKeyPressed( key_action2 ) && (blob.get_string( "current tool" ) == "deconstructor") )
			{
					this.SetAnimation("reclaim");
			}
			else if (blob.isKeyPressed( key_action2 ) && (blob.get_string( "current tool" ) == "reconstructor") )
			{
					this.SetAnimation("repair");
			}
			else if (blob.getShape().vellen > 0.1f) {
				this.SetAnimation("swim");
			}
			else if (blob.isKeyPressed( key_action2 ) && canShootPistol( blob ))
			{
					this.SetAnimation("shoot");
			}
			else {
				this.SetAnimation("float");
			}
		}
	}

	this.SetZ( 540.0f );
}