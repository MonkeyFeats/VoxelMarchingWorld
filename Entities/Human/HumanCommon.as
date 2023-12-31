namespace Human
{
	const float walkSpeed = 1.5f;
	const float swimSlow = 4.8f;
};

// helper functions

namespace Human
{
	bool isHoldingBlocks( CBlob@ this )
	{
	   	CBlob@[]@ blob_blocks;
	    this.get( "blocks", @blob_blocks );
	    return blob_blocks.length > 0;
	}
	
	bool wasHoldingBlocks( CBlob@ this )
	{
		return getGameTime() - this.get_u32( "placedTime" ) < 10;
	}
	
	void clearHeldBlocks( CBlob@ this )
	{
		CBlob@[]@ blocks;
		if (this.get( "blocks", @blocks ))                 
		{
			for (uint i = 0; i < blocks.length; ++i)
			{
				blocks[i].Tag( "disabled" );
				blocks[i].server_Die();
			}

			blocks.clear();
		}
	}
}

const string camera_sync_cmd = "camerasync";

void SyncCamera(CBlob@ this)
{
	CBitStream bt;
	bt.write_f32(this.get_f32("dir_x"));
	
	uint8 cmnd = this.getCommandID(camera_sync_cmd);

	this.SendCommand(cmnd, bt);
}

void HandleCamera(CBlob@ this, CBitStream@ bt, bool apply)
{
	if(!apply) return;
	
	float dirX;
	if(!bt.saferead_f32(dirX)) return;

	if (dirX > 720)
	dirX = -720;
	else if (dirX < -720)
	dirX = 720;

	this.set_f32("dir_x", dirX);
}