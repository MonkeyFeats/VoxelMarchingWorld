
void GenerateTerain()
{
	CMap@ map = getMap();
	Random@ map_random = Random(map.getMapSeed());
	Noise@ map_noise = Noise(map_random.Next());
	Noise@ material_noise = Noise(map_random.Next());

	const string MapName = map.getMapName();

	if(!Texture::exists(MapName))
	{
		Texture::createFromFile(MapName, MapName);
	}
	ImageData@ heightmap = Texture::data(MapName);

	for (uint x = 0; x <= heightmap.width(); ++x) 
	{	
		for (uint y = 0; y <= heightmap.width(); ++y) 
		{
			for (uint z = 0; z <= heightmap.width(); ++z) 
			{
				SColor pixel = heightmap.get(x, y);	

				if (pixel == CMap::color_grass)
				{
					data[x][y].push_back(1);
				}
				else
				{
					data[x][y].push_back(0);
				}
			}	
		}
	}		
}
