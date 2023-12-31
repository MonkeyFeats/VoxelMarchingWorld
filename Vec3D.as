//Vec3dClass.as
 
class Vec3d
{
    float x;
    float y;
    float z;
   
    Vec3d(){}
   
    Vec3d(float _x, float _y, float _z)
    {
        x = _x;
        y = _y;
        z = _z;
    }   
   
    Vec3d(Vec3d vec, float mag)
    {
        vec.Normalize();
        if(mag == 0)
            print("invalid vector");
        x=mag*vec.x;
        y=mag*vec.y;
        z=mag*vec.z;
    }
   
    Vec3d opAdd(const Vec3d &in oof)
    {
        return Vec3d(x + oof.x, y + oof.y, z + oof.z);
    }
   
    Vec3d opSub(const Vec3d &in oof)
    {
        return Vec3d(x - oof.x, y - oof.y, z - oof.z);
    }
   
    Vec3d opMul(const Vec3d &in oof)
    {
        return Vec3d(x * oof.x, y * oof.y, z * oof.z);
    }
   
    Vec3d opMul(const float &in oof)
    {
        return Vec3d(x * oof, y * oof, z * oof);
    }
   
    Vec3d opDiv(const Vec3d &in oof)
    {
        return Vec3d(x / oof.x, y / oof.y, z / oof.z);
    }
   
    Vec3d opDiv(const float &in oof)
    {
        return Vec3d(x / oof, y / oof, z / oof);
    }

    float DotProd(const Vec3d &in v2) 
    {
        float dotProduct = (x + v2.x ) + (y + v2.y) + (z + v2.z);
        return dotProduct;
    }

    Vec3d CrossProd(const Vec3d &in v2) 
    {
        Vec3d crossProduct;
        crossProduct.x = (y * v2.z ) - (z * v2.y);
        crossProduct.y = (z * v2.x ) - (x * v2.z);
        crossProduct.z = (x * v2.y ) - (y * v2.x);

        return crossProduct;
    }
    float AngleWith(Vec3d to)
    {
        Vec3d from(x,y,z);
        from.Normalize();
        to.Normalize();

        return Maths::ATan2(from.x-to.x, from.y-to.y);
    }
   
   // void opAddAssign(const Vec3d &in oof)
   // {
   //     x+=oof.x;
   //     y+=oof.y;
   //     z+=oof.z;
   // }
   //
   // void opAssign(const Vec3d &in oof)
   // {
   //     x=oof.x;
   //     y=oof.y;
   //     z=oof.z;
   // }
   
    Vec3d unit()
    {
        float length = this.mag();
        if(length == 0)
            print("(uint) invalid vector");
        return Vec3d(x/length, y/length, z/length);
    }
   
    Vec3d lerp(Vec3d desired, float t)
    {
        return Vec3d((((1 - t) * this.x) + (t * desired.x)), (((1 - t) * this.y) + (t * desired.y)), (((1 - t) * this.z) + (t * desired.z)));
    }
   
    void print_self()
    {
        print("x: "+x+"; y: "+y+"; z: "+z);
    }
   
    void Normalize()
    {
        float length = this.mag();
        if(length == 0)
            print("(Normalize) invalid vector");
        x /= length;
        y /= length;
        z /= length;
    }

    float Normalized()
    {
        float length = this.mag();
        if(length == 0)
            print("(Normalize) invalid vector");
        x /= length;
        y /= length;
        z /= length;
        return (x+y+z);
    }
   
    float mag()
    {
        //print("x: "+x);
        //print("y: "+y);
        //print("z: "+z);
        float boi = Maths::Sqrt(x*x + y*y + z*z);
        //print("boi: "+boi);
        if(boi == 0) return 1;
        return boi;
    }
}