package nape.phys;
import zpp_nape.Const;
import zpp_nape.ID;
import zpp_nape.util.Array2;
import zpp_nape.util.Circular;
import zpp_nape.util.DisjointSetForest;
import zpp_nape.util.FastHash;
import zpp_nape.util.Flags;
import zpp_nape.util.Lists;
import zpp_nape.util.Math;
import zpp_nape.util.Names;
import zpp_nape.util.Pool;
import zpp_nape.util.Queue;
import zpp_nape.util.RBTree;
import zpp_nape.util.Debug;
import zpp_nape.util.UserData;
import zpp_nape.util.WrapLists;
import zpp_nape.space.Broadphase;
import zpp_nape.space.DynAABBPhase;
import zpp_nape.space.SweepPhase;
import zpp_nape.shape.Circle;
import zpp_nape.shape.Edge;
import zpp_nape.shape.Polygon;
import zpp_nape.shape.Shape;
import zpp_nape.phys.Body;
import zpp_nape.phys.Compound;
import zpp_nape.phys.FeatureMix;
import zpp_nape.phys.FluidProperties;
import zpp_nape.phys.Interactor;
import zpp_nape.phys.Material;
import zpp_nape.geom.AABB;
import zpp_nape.geom.Collide;
import zpp_nape.geom.Convex;
import zpp_nape.geom.ConvexRayResult;
import zpp_nape.space.Space;
import zpp_nape.geom.Cutter;
import zpp_nape.geom.Geom;
import zpp_nape.geom.GeomPoly;
import zpp_nape.geom.Mat23;
import zpp_nape.geom.MarchingSquares;
import zpp_nape.geom.MatMN;
import zpp_nape.geom.MatMath;
import zpp_nape.geom.Monotone;
import zpp_nape.geom.PolyIter;
import zpp_nape.geom.PartitionedPoly;
import zpp_nape.geom.Ray;
import zpp_nape.geom.Simplify;
import zpp_nape.geom.Simple;
import zpp_nape.geom.SweepDistance;
import zpp_nape.geom.Vec2;
import zpp_nape.geom.Vec3;
import zpp_nape.geom.Triangular;
import zpp_nape.geom.VecMath;
import zpp_nape.dynamics.Contact;
import zpp_nape.dynamics.InteractionFilter;
import zpp_nape.dynamics.InteractionGroup;
import zpp_nape.dynamics.SpaceArbiterList;
import zpp_nape.constraint.AngleJoint;
import zpp_nape.constraint.Constraint;
import zpp_nape.dynamics.Arbiter;
import zpp_nape.constraint.DistanceJoint;
import zpp_nape.constraint.LinearJoint;
import zpp_nape.constraint.MotorJoint;
import zpp_nape.constraint.PivotJoint;
import zpp_nape.constraint.LineJoint;
import zpp_nape.constraint.UserConstraint;
import zpp_nape.constraint.WeldJoint;
import zpp_nape.constraint.PulleyJoint;
import zpp_nape.callbacks.Callback;
import zpp_nape.callbacks.CbSetPair;
import zpp_nape.callbacks.CbType;
import zpp_nape.callbacks.CbSet;
import zpp_nape.callbacks.OptionType;
import zpp_nape.callbacks.Listener;
import nape.Config;
import nape.TArray;
import nape.util.Debug;
import nape.util.BitmapDebug;
import nape.space.Broadphase;
import nape.util.ShapeDebug;
import nape.shape.Circle;
import nape.shape.Edge;
import nape.shape.EdgeIterator;
import nape.shape.EdgeList;
import nape.space.Space;
import nape.shape.Polygon;
import nape.shape.ShapeIterator;
import nape.shape.ShapeList;
import nape.shape.ShapeType;
import nape.shape.ValidationResult;
import nape.shape.Shape;
import nape.phys.BodyIterator;
import nape.phys.BodyList;
import nape.phys.BodyType;
import nape.phys.Compound;
import nape.phys.CompoundIterator;
import nape.phys.CompoundList;
import nape.phys.FluidProperties;
import nape.phys.GravMassMode;
import nape.phys.InertiaMode;
import nape.phys.InteractorIterator;
import nape.phys.InteractorList;
import nape.phys.MassMode;
import nape.phys.Body;
import nape.phys.Material;
import nape.geom.ConvexResult;
import nape.geom.ConvexResultIterator;
import nape.geom.ConvexResultList;
import nape.geom.AABB;
import nape.geom.Geom;
import nape.geom.GeomPolyIterator;
import nape.geom.GeomPolyList;
import nape.geom.GeomVertexIterator;
import nape.geom.IsoFunction;
import nape.geom.MarchingSquares;
import nape.geom.GeomPoly;
import nape.geom.MatMN;
import nape.geom.Mat23;
import nape.geom.Ray;
import nape.geom.RayResultIterator;
import nape.geom.RayResultList;
import nape.geom.RayResult;
import nape.geom.Vec2Iterator;
import nape.geom.Vec2List;
import nape.geom.Vec3;
import nape.geom.Winding;
import nape.dynamics.Arbiter;
import nape.dynamics.ArbiterIterator;
import nape.geom.Vec2;
import nape.dynamics.ArbiterList;
import nape.dynamics.ArbiterType;
import nape.dynamics.Contact;
import nape.dynamics.ContactIterator;
import nape.dynamics.ContactList;
import nape.dynamics.FluidArbiter;
import nape.dynamics.CollisionArbiter;
import nape.dynamics.InteractionFilter;
import nape.dynamics.InteractionGroupIterator;
import nape.dynamics.InteractionGroupList;
import nape.dynamics.InteractionGroup;
import nape.constraint.AngleJoint;
import nape.constraint.ConstraintIterator;
import nape.constraint.ConstraintList;
import nape.constraint.DistanceJoint;
import nape.constraint.LinearJoint;
import nape.constraint.Constraint;
import nape.constraint.LineJoint;
import nape.constraint.PivotJoint;
import nape.constraint.MotorJoint;
import nape.constraint.PulleyJoint;
import nape.constraint.UserConstraint;
import nape.constraint.WeldJoint;
import nape.callbacks.BodyCallback;
import nape.callbacks.Callback;
import nape.callbacks.BodyListener;
import nape.callbacks.CbEvent;
import nape.callbacks.CbTypeIterator;
import nape.callbacks.CbTypeList;
import nape.callbacks.ConstraintCallback;
import nape.callbacks.CbType;
import nape.callbacks.InteractionCallback;
import nape.callbacks.ConstraintListener;
import nape.callbacks.InteractionType;
import nape.callbacks.InteractionListener;
import nape.callbacks.ListenerIterator;
import nape.callbacks.ListenerList;
import nape.callbacks.ListenerType;
import nape.callbacks.Listener;
import nape.callbacks.OptionType;
import nape.callbacks.PreFlag;
import nape.callbacks.PreCallback;
import nape.callbacks.PreListener;
#if nape_swc@:keep #end
class Interactor{
    /**
     * @private
     */
    public var zpp_inner_i:ZPP_Interactor=null;
    /**
     * Unique id of this Interactor.
     */
    #if nape_swc@:isVar #end
    public var id(get,never):Int;
    inline function get_id():Int{
        return zpp_inner_i.id;
    }
    /**
     * Dynamic object for user to store additional data.
     * <br/><br/>
     * This object cannot be set, only its dynamically created
     * properties may be set. In AS3 the type of this property is &#42
     * <br/><br/>
     * This object will be lazily constructed so that until accessed
     * for the first time, will be null internally.
     *
     * @default {}
     */
    #if nape_swc@:isVar #end
    public var userData(get,never):Dynamic<Dynamic>;
    inline function get_userData():Dynamic<Dynamic>{
        if(zpp_inner_i.userData==null){
            zpp_inner_i.userData=cast{};
        }
        return zpp_inner_i.userData;
    }
    /**
     * Fast equivalent to <code>(interactor is  Shape)</code>
     * @return true if this Interactor is a Shape.
     */
    public#if NAPE_NO_INLINE#else inline #end
    function isShape(){
        return zpp_inner_i.ishape!=null;
    }
    /**
     * Fast equivalent to <code>(interactor is  Body)</code>
     * @return true if this Interactor is a Body.
     */
    public#if NAPE_NO_INLINE#else inline #end
    function isBody(){
        return zpp_inner_i.ibody!=null;
    }
    /**
     * Fast equivalent to <code>(interactor is  Compound)</code>
     * @return true if this Interactor is a Compound.
     */
    public#if NAPE_NO_INLINE#else inline #end
    function isCompound(){
        return zpp_inner_i.icompound!=null;
    }
    /**
     * Fast equivalent to <code>cast(interactor, Shape)</code>
     */
    #if nape_swc@:isVar #end
    public var castShape(get,never):Null<Shape>;
    inline function get_castShape():Null<Shape>{
        return if(isShape())zpp_inner_i.ishape.outer else null;
    }
    /**
     * Fast equivalent to <code>cast(interactor, Body)</code>
     */
    #if nape_swc@:isVar #end
    public var castBody(get,never):Null<Body>;
    inline function get_castBody():Null<Body>{
        return if(isBody())zpp_inner_i.ibody.outer else null;
    }
    /**
     * Fast equivalent to <code>cast(interactor, Compound)</code>
     */
    #if nape_swc@:isVar #end
    public var castCompound(get,never):Null<Compound>;
    inline function get_castCompound():Null<Compound>{
        return if(isCompound())zpp_inner_i.icompound.outer else null;
    }
    /**
     * InteractionGroup assigned to this Interactor.
     *
     * @default null
     */
    #if nape_swc@:isVar #end
    public var group(get,set):Null<InteractionGroup>;
    inline function get_group():Null<InteractionGroup>{
        return if(zpp_inner_i.group==null)null else zpp_inner_i.group.outer;
    }
    inline function set_group(group:Null<InteractionGroup>):Null<InteractionGroup>{
        {
            zpp_inner_i.immutable_midstep("Interactor::group");
            zpp_inner_i.setGroup(group==null?null:group.zpp_inner);
        }
        return get_group();
    }
    /**
     * Set of CbType's assigned to this Interactor.
     *
     * @default []
     */
    #if nape_swc@:isVar #end
    public var cbTypes(get,never):CbTypeList;
    inline function get_cbTypes():CbTypeList{
        if(zpp_inner_i.wrap_cbTypes==null)zpp_inner_i.setupcbTypes();
        return zpp_inner_i.wrap_cbTypes;
    }
    /**
     * @private
     */
    #if(!NAPE_RELEASE_BUILD)
    public static var zpp_internalAlloc=false;
    #end
    public function new(){
        #if(!NAPE_RELEASE_BUILD)
        if(!zpp_internalAlloc)throw "Error: Cannot instantiate an Interactor, only Shape/Body/Compound";
        #end
    }
    /**
     * @private
     */
    @:keep public function toString(){
        return "";
    }
}
