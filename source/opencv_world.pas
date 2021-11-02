unit opencv_world;

interface

Uses
  opencv_delphi;

{$I opencv_delphi.inc}
{$REGION 'CV const'}

const
  INT_MAX = MaxInt;
  DBL_MAX = 1.7976931348623158E+308; // max value
{$ENDREGION 'CV const'}
  //
{$REGION 'Interface.h'}

const
  CV_CN_MAX    = 512;
  CV_CN_SHIFT  = 3;
  CV_DEPTH_MAX = (1 shl CV_CN_SHIFT);

  CV_8U  = 0;
  CV_8S  = 1;
  CV_16U = 2;
  CV_16S = 3;
  CV_32S = 4;
  CV_32F = 5;
  CV_64F = 6;
  CV_16F = 7;

  CV_MAT_DEPTH_MASK = (CV_DEPTH_MAX - 1);
function CV_MAT_DEPTH(flags: int): int; {$IFDEF USE_INLINE}inline; {$ENDIF}     // #define CV_MAT_DEPTH(flags)     ((flags) & CV_MAT_DEPTH_MASK)
function CV_MAKETYPE(depth, cn: int): int; {$IFDEF USE_INLINE}inline; {$ENDIF}  // #define CV_MAKETYPE(depth,cn) (CV_MAT_DEPTH(depth) + (((cn)-1) << CV_CN_SHIFT))
function CV_MAKE_TYPE(depth, cn: int): int; {$IFDEF USE_INLINE}inline; {$ENDIF} // #define CV_MAKE_TYPE CV_MAKETYPE

Var
  CV_8UC1: int;
  CV_8UC2: int;
  CV_8UC3: int;
  CV_8UC4: int;

function CV_8UC(n: int): int; {$IFDEF USE_INLINE}inline; {$ENDIF} // CV_8UC(n) CV_MAKETYPE(CV_8U,(n))

{$ENDREGION 'Interface.h'}
//
{$REGION 'base.hpp'}

type
  // ! Various border types, image boundaries are denoted with `|`
  // ! @see borderInterpolate, copyMakeBorder
  BorderTypes = (           //
    BORDER_CONSTANT = 0,    // !< `iiiiii|abcdefgh|iiiiiii`  with some specified `i`
    BORDER_REPLICATE = 1,   // !< `aaaaaa|abcdefgh|hhhhhhh`
    BORDER_REFLECT = 2,     // !< `fedcba|abcdefgh|hgfedcb`
    BORDER_WRAP = 3,        // !< `cdefgh|abcdefgh|abcdefg`
    BORDER_REFLECT_101 = 4, // !< `gfedcb|abcdefgh|gfedcba`
    BORDER_TRANSPARENT = 5, // !< `uvwxyz|abcdefgh|ijklmno`

    BORDER_REFLECT101 = BORDER_REFLECT_101, // !< same as BORDER_REFLECT_101
    BORDER_DEFAULT = BORDER_REFLECT_101,    // !< same as BORDER_REFLECT_101
    BORDER_ISOLATED = 16                    // !< do not look outside of ROI
    );
{$ENDREGION 'base.hpp'}
  //
{$REGION 'cvdef.h'}

const
  (* ************************************************************************************** *)
  (* Matrix type (Mat) *)
  (* ************************************************************************************** *)

  CV_MAT_CN_MASK = ((CV_CN_MAX - 1) shl CV_CN_SHIFT);
  // CV_MAT_CN(flags)       = ((((flags) & CV_MAT_CN_MASK) >> CV_CN_SHIFT) + 1);
  CV_MAT_TYPE_MASK = (CV_DEPTH_MAX * CV_CN_MAX - 1);
  // CV_MAT_TYPE(flags)     = ((flags) & CV_MAT_TYPE_MASK);
  CV_MAT_CONT_FLAG_SHIFT = 14;
  CV_MAT_CONT_FLAG       = (1 shl CV_MAT_CONT_FLAG_SHIFT);
  // CV_IS_MAT_CONT(flags)  = ((flags) & CV_MAT_CONT_FLAG);
  CV_IS_CONT_MAT       = CV_MAT_CONT_FLAG; // CV_IS_MAT_CONT;
  CV_SUBMAT_FLAG_SHIFT = 15;
  CV_SUBMAT_FLAG       = (1 shl CV_SUBMAT_FLAG_SHIFT);
  // CV_IS_SUBMAT(flags)    = ((flags) & CV_MAT_SUBMAT_FLAG);

  OPENCV_ABI_COMPATIBILITY = 400;

type
  TRect_<T> = record
  public
    // ! default constructor
    // Rect_();
    // Rect_(_Tp _x, _Tp _y, _Tp _width, _Tp _height);
    // #if OPENCV_ABI_COMPATIBILITY < 500
    // Rect_(const Rect_& r) = default;
    // Rect_(Rect_&& r) CV_NOEXCEPT = default;
    // #endif
    // Rect_(const Point_<_Tp>& org, const Size_<_Tp>& sz);
    // Rect_(const Point_<_Tp>& pt1, const Point_<_Tp>& pt2);
    //
    // #if OPENCV_ABI_COMPATIBILITY < 500
    // Rect_& operator = (const Rect_& r) = default;
    // Rect_& operator = (Rect_&& r) CV_NOEXCEPT = default;
    // #endif
    // ! the top-left corner
    // Point_<_Tp> tl() const;
    // ! the bottom-right corner
    // Point_<_Tp> br() const;

    // ! size (width, height) of the rectangle
    // Size_<_Tp> size() const;
    // ! area (width*height) of the rectangle
    // _Tp area() const;
    // ! true if empty
    // bool empty() const;

    // ! conversion to another data type
    // template<typename _Tp2> operator Rect_<_Tp2>() const;

    // ! checks whether the rectangle contains the point
    // bool contains(const Point_<_Tp>& pt) const;
  public
    x: T;      // !< x coordinate of the top-left corner
    y: T;      // !< y coordinate of the top-left corner
    width: T;  // !< width of the rectangle
    height: T; // !< height of the rectangle
  end;

  TRect2i = TRect_<int>;
  TRect = TRect2i;
  pRect = ^TRect;
{$ENDREGION 'cvdef.h'}
  //
{$REGION 'types.hpp'}

Type
  TSize_<T> = record
  public
    // //! default constructor
    // Size_();
    class function size(const _width, _height: T): TSize_<T>; static; // Size_(_Tp _width, _Tp _height);
    // #if OPENCV_ABI_COMPATIBILITY < 500
    // Size_(const Size_& sz) = default;
    // Size_(Size_&& sz) CV_NOEXCEPT = default;
    // #endif
    // Size_(const Point_<_Tp>& pt);
    //
    // #if OPENCV_ABI_COMPATIBILITY < 500
    // Size_& operator = (const Size_& sz) = default;
    // Size_& operator = (Size_&& sz) CV_NOEXCEPT = default;
    // #endif
    // //! the area (width*height)
    // _Tp area() const;
    // //! aspect ratio (width/height)
    // double aspectRatio() const;
    // //! true if empty
    // bool empty() const;
    //
    // //! conversion of another data type.
    // template<typename _Tp2> operator Size_<_Tp2>() const;
  public
    width: T;  // _Tp width;  // !< the width
    height: T; // _Tp height; // !< the height
  end;

  TSize2i = TSize_<int>;
  TSize = TSize2i;
  pSize = UInt64;
  rSize = ^TSize;

function size(const _width, _height: int): TSize; {$IFDEF USE_INLINE}inline; {$ENDIF}

type
  TPoint_<T> = record
  public
    // ! default constructor
    // Point_();
    class function Point(_x, _y: T): TPoint_<T>; static; // Point_(_Tp _x, _Tp _y);
    // #if (defined(__GNUC__) && __GNUC__ < 5)  // GCC 4.x bug. Details: https://github.com/opencv/opencv/pull/20837
    // Point_(const Point_& pt);
    // Point_(Point_&& pt) CV_NOEXCEPT = default;
    // #elif OPENCV_ABI_COMPATIBILITY < 500
    // Point_(const Point_& pt) = default;
    // Point_(Point_&& pt) CV_NOEXCEPT = default;
    // #endif
    // Point_(const Size_<_Tp>& sz);
    // Point_(const Vec<_Tp, 2>& v);
    //
    // #if (defined(__GNUC__) && __GNUC__ < 5)  // GCC 4.x bug. Details: https://github.com/opencv/opencv/pull/20837
    // Point_& operator = (const Point_& pt);
    // Point_& operator = (Point_&& pt) CV_NOEXCEPT = default;
    // #elif OPENCV_ABI_COMPATIBILITY < 500
    // Point_& operator = (const Point_& pt) = default;
    // Point_& operator = (Point_&& pt) CV_NOEXCEPT = default;
    // #endif
    // ! conversion to another data type
    // template<typename _Tp2> operator Point_<_Tp2>() const;

    // ! conversion to the old-style C structures
    // operator Vec<_Tp, 2>() const;

    // ! dot product
    // _Tp dot(const Point_& pt) const;
    // ! dot product computed in double-precision arithmetics
    // double ddot(const Point_& pt) const;
    // ! cross-product
    // double cross(const Point_& pt) const;
    // ! checks whether the point is inside the specified rectangle
    // bool inside(const Rect_<_Tp>& r) const;
  public
    x: T; // !< x coordinate of the point
    y: T; // !< y coordinate of the point
  end;

  TPoint2i = TPoint_<int>;
  TPoint = TPoint2i;
  pPoint = UInt64;
  rPoint = ^TPoint;

function Point(const _x, _y: int): TPoint; {$IFDEF USE_INLINE}inline; {$ENDIF}
{$ENDREGION 'types.hpp'}
//
{$REGION 'mat.hpp'}

Type

  TCVMat = array [0 .. 95] of byte;    // forward declaration
  TCVScalar = array [0 .. 31] of byte; // forward declaration

  pMatSize = ^TMatSize;

  TMatSize = record
  public
    // explicit MatSize(int* _p) CV_NOEXCEPT;
    // int dims() const CV_NOEXCEPT;
    class operator Implicit(const m: TMatSize): TSize; // Size operator()() const;
    // const int& operator[](int i) const;
    // int& operator[](int i);
    // operator const int*() const CV_NOEXCEPT;  // TODO OpenCV 4.0: drop this
    // bool operator == (const MatSize& sz) const CV_NOEXCEPT;
    // bool operator != (const MatSize& sz) const CV_NOEXCEPT;
  private
{$HINTS OFF}
    p: pInt; // pInt; // int* p;
{$HINTS ON}
  end;

  TMatStep = record
    // MatStep() CV_NOEXCEPT;
    // explicit MatStep(size_t s) CV_NOEXCEPT;
    // const size_t& operator[](int i) const CV_NOEXCEPT;
    // size_t& operator[](int i) CV_NOEXCEPT;
    // operator size_t() const;
    // MatStep& operator = (size_t s);
    p: psize_t;                    // size_t* p;
    buf: array [0 .. 1] of size_t; // size_t buf[2];
  end;

  pMatExpr = ^TMatExpr;

  TMatExpr = record
  public
    class operator Initialize(out Dest: TMatExpr); // MatExpr();
    // explicit MatExpr(const Mat& m);
    //
    // MatExpr(const MatOp* _op, int _flags, const Mat& _a = Mat(), const Mat& _b = Mat(),
    // const Mat& _c = Mat(), double _alpha = 1, double _beta = 1, const Scalar& _s = Scalar());
    //
    // operator Mat() const;
    //
    function size: TSize; {$IFDEF USE_INLINE}inline; {$ENDIF} // Size size() const;
    // int type() const;
    //
    // MatExpr row(int y) const;
    // MatExpr col(int x) const;
    // MatExpr diag(int d = 0) const;
    // MatExpr operator()( const Range& rowRange, const Range& colRange ) const;
    // MatExpr operator()( const Rect& roi ) const;
    //
    // MatExpr t() const;
    // MatExpr inv(int method = DECOMP_LU) const;
    // MatExpr mul(const MatExpr& e, double scale=1) const;
    // MatExpr mul(const Mat& m, double scale=1) const;
    //
    // Mat cross(const Mat& m) const;
    // double dot(const Mat& m) const;
    //
    // void swap(MatExpr& b);
    //
    class operator Finalize(var Dest: TMatExpr);
  public
    op: pMatOp; // pMatOp; // const MatOp* op;
    flags: int; // int flags;
    //
    a, b, c: TCVMat;     // Mat a, b, c;
    alpha, beta: double; // double alpha, beta;
    s: TCVScalar;        // Scalar s;
  end;

  pMat = ^TMat;

  TMat = record // 96 bytes, v4.5.4
  public
    // default constructor
    class operator Initialize(out Dest: TMat); // Mat();
    // constructors
    // Mat(Size size, int type);
    // Mat(int rows, int cols, int type, const Scalar& s);
    // Mat(Size size, int type, const Scalar& s);
    // Mat(int ndims, const int* sizes, int type);
    // Mat(const std::vector<int>& sizes, int type);
    // Mat(int ndims, const int* sizes, int type, const Scalar& s);
    // Mat(const std::vector<int>& sizes, int type, const Scalar& s);
    // Mat(const Mat& m);
    // Mat(int rows, int cols, int type, void* data, size_t step=AUTO_STEP);
    // Mat(Size size, int type, void* data, size_t step=AUTO_STEP);
    // Mat(int ndims, const int* sizes, int type, void* data, const size_t* steps=0);
    // Mat(const std::vector<int>& sizes, int type, void* data, const size_t* steps=0);
    // Mat(const Mat& m, const Range& rowRange, const Range& colRange=Range::all());
    // Mat(const Mat& m, const Rect& roi);
    // Mat(const Mat& m, const Range* ranges);
    // Mat(const Mat& m, const std::vector<Range>& ranges);

    // default destructor
    class operator Finalize(var Dest: TMat); // ~Mat();
    class operator assign(var Dest: TMat; const [ref] Src: TMat);

    // Mat& operator = (const Mat& m);
    class operator Implicit(const m: TMatExpr): TMat; // Mat& operator = (const MatExpr& expr);
    // UMat getUMat(AccessFlag accessFlags, UMatUsageFlags usageFlags = USAGE_DEFAULT) const;
    // Mat row(int y) const;
    // Mat col(int x) const;
    // Mat rowRange(int startrow, int endrow) const;
    // Mat rowRange(const Range& r) const;
    // Mat colRange(int startcol, int endcol) const;
    // Mat colRange(const Range& r) const;
    function diag(d: int = 0): TMat; {$IFDEF USE_INLINE}inline; {$ENDIF} // Mat diag(int d=0) const;
    // CV_NODISCARD_STD static Mat diag(const Mat& d);
    // procedure clone(R: pCVMatPointer); // CV_NODISCARD_STD Mat clone() const;
    function clone: TMat; {$IFDEF USE_INLINE}inline; {$ENDIF}
    // void copyTo( OutputArray m ) const;
    // void copyTo( OutputArray m, InputArray mask ) const;
    // void convertTo( OutputArray m, int rtype, double alpha=1, double beta=0 ) const;
    // void assignTo( Mat& m, int type=-1 ) const;
    // Mat& operator = (const Scalar& s);
    // Mat& setTo(InputArray value, InputArray mask=noArray());
    // Mat reshape(int cn, int rows=0) const;
    // Mat reshape(int cn, int newndims, const int* newsz) const;
    // Mat reshape(int cn, const std::vector<int>& newshape) const;
    // MatExpr t() const;
    // MatExpr inv(int method=DECOMP_LU) const;
    // MatExpr mul(InputArray m, double scale=1) const;
    // Mat cross(InputArray m) const;
    // double dot(InputArray m) const;
    // CV_NODISCARD_STD static MatExpr zeros(int rows, int cols, int type);
    class function zeros(const size: TSize; &type: int): TMatExpr; static; // CV_NODISCARD_STD static MatExpr zeros(Size size, int type);
    // CV_NODISCARD_STD static MatExpr zeros(int ndims, const int* sz, int type);
    class function ones(rows: int; cols: int; &type: int): TMatExpr; overload; static; // CV_NODISCARD_STD static MatExpr ones(int rows, int cols, int type);
    // CV_NODISCARD_STD static MatExpr ones(Size size, int type);
    class function ones(ndims: int; const sz: pInt; &type: int): TMat; overload; static; // CV_NODISCARD_STD static MatExpr ones(int ndims, const int* sz, int type);
    // CV_NODISCARD_STD static MatExpr eye(int rows, int cols, int type);
    // CV_NODISCARD_STD static MatExpr eye(Size size, int type);
    procedure create(rows, cols, &type: int); {$IFDEF USE_INLINE}inline; {$ENDIF} // void create(int rows, int cols, int type);
    // void create(Size size, int type);
    // void create(int ndims, const int* sizes, int type);
    // void create(const std::vector<int>& sizes, int type);
    // void addref();
    // void release();
    // // ! internal use function, consider to use 'release' method instead; deallocates the matrix data
    // void deallocate();
    // // ! internal use function; properly re-allocates _size, _step arrays
    // void copySize(const Mat& m);
    // void reserve(size_t sz);
    // void reserveBuffer(size_t sz);
    // void resize(size_t sz);
    // void resize(size_t sz, const Scalar& s);
    // //! internal function
    // void push_back_(const void* elem);
    // void push_back(const Mat& m);
    // void pop_back(size_t nelems=1);
    // void locateROI( Size& wholeSize, Point& ofs ) const;
    // Mat& adjustROI( int dtop, int dbottom, int dleft, int dright );
    // Mat operator()( Range rowRange, Range colRange ) const;
    // Mat operator()( const Rect& roi ) const;
    // Mat operator()( const Range* ranges ) const;
    // Mat operator()(const std::vector<Range>& ranges) const;
    function isContinuous: Bool; {$IFDEF USE_INLINE}inline; {$ENDIF} // bool isContinuous() const;
    // //! returns true if the matrix is a submatrix of another matrix
    function isSubmatrix: Bool; {$IFDEF USE_INLINE}inline; {$ENDIF}         // bool isSubmatrix() const;
    function elemSize: size_t; {$IFDEF USE_INLINE}inline; {$ENDIF}          // size_t elemSize() const;
    function elemSize1: size_t; {$IFDEF USE_INLINE}inline; {$ENDIF}         // size_t elemSize1() const;
    function &type: int; {$IFDEF USE_INLINE}inline; {$ENDIF}                // int type() const;
    function depth: int; {$IFDEF USE_INLINE}inline; {$ENDIF}                // int depth() const;
    function channels: int; {$IFDEF USE_INLINE}inline; {$ENDIF}             // int channels() const;
    function step1(i: int = 0): size_t; {$IFDEF USE_INLINE}inline; {$ENDIF} // size_t step1(int i=0) const;
    function empty: Bool; {$IFDEF USE_INLINE}inline; {$ENDIF}               // bool empty() const;
    function total: size_t; overload; {$IFDEF USE_INLINE}inline; {$ENDIF}   // size_t total() const;
    function total(startDim: int; endDim: int = INT_MAX): size_t; overload; {$IFDEF USE_INLINE}inline; {$ENDIF} // size_t total(int startDim, int endDim=INT_MAX) const;
    function checkVector(elemChannels: int; depth: int = -1; requireContinuous: Bool = true): int; {$IFDEF USE_INLINE}inline; {$ENDIF} // int checkVector(int elemChannels, int depth=-1, bool requireContinuous=true) const;
    // uchar* ptr(int i0=0);
    // const uchar* ptr(int i0=0) const;
    // uchar* ptr(int row, int col);
    // const uchar* ptr(int row, int col) const;
    // uchar* ptr(int i0, int i1, int i2);
    // const uchar* ptr(int i0, int i1, int i2) const;
    // uchar* ptr(const int* idx);
    // const uchar* ptr(const int* idx) const;
    // Mat(Mat&& m);
    // Mat& operator = (Mat&& m);
    class operator LogicalNot(const m: TMat): TMatExpr;
  public const
    MAGIC_VAL       = $42FF0000;
    AUTO_STEP       = 0;
    CONTINUOUS_FLAG = CV_MAT_CONT_FLAG;
    SUBMATRIX_FLAG  = CV_SUBMAT_FLAG;

    MAGIC_MASK = $FFFF0000;
    TYPE_MASK  = $00000FFF;
    DEPTH_MASK = 7;
  public
    // CVMat: TCVMat;
    flags: int; // int flags;
    // ! the matrix dimensionality, >= 2
    dims: int; // int dims;
    // ! the number of rows and columns or (-1, -1) when the matrix has more than 2 dimensions
    rows, cols: int; // int rows, cols;
    // ! pointer to the data
    data: pUChar; // uchar* data;
    //
    // ! helper fields used in locateROI and adjustROI
    datastart: pUChar; // const uchar* datastart;
    dataend: pUChar;   // const uchar* dataend;
    datalimit: pUChar; // const uchar* datalimit;
    //
    // ! custom allocator
    allocator: pMatAllocator; // MatAllocator* allocator;
    // ! and the standard allocator
    // static MatAllocator* getStdAllocator();
    // static MatAllocator* getDefaultAllocator();
    // static void setDefaultAllocator(MatAllocator* allocator);
    //
    // ! internal use method: updates the continuity flag
    // void updateContinuityFlag();
    //
    // ! interaction with UMat
    u: pUMatData; // UMatData* u;
    //
    size: TMatSize; // MatSize size;
    step: TMatStep; // MatStep step;
  end;

  pScalar = ^TScalar;

  TScalar = record
  private
{$HINTS OFF}
    V: array [0 .. 3] of double;
{$HINTS ON}
  public
    class operator Initialize(out Dest: TScalar); // Scalar_();
    class function create(const v0, v1: double; const v2: double = 0; const v3: double = 0): TScalar; overload; static; // Scalar_(_Tp v0, _Tp v1, _Tp v2=0, _Tp v3=0);
    class function create(const v0: double): TScalar; overload; static; // Scalar_(_Tp v0);
    // Scalar_(const Scalar_& s);
    // Scalar_(Scalar_&& s) CV_NOEXCEPT;
    // Scalar_& operator=(const Scalar_& s);
    // Scalar_& operator=(Scalar_&& s) CV_NOEXCEPT;
    // Scalar_(const Vec<_Tp2, cn>& v);
    // //! returns a scalar with all elements set to v0
    class function all(const v0: double): TScalar; static; // static Scalar_<_Tp> all(_Tp v0);
    // //! per-element product
    // Scalar_<_Tp> mul(const Scalar_<_Tp>& a, double scale=1 ) const;
    // //! returns (v0, -v1, -v2, -v3)
    // Scalar_<_Tp> conj() const;
    // //! returns true iff v1 == v2 == v3 == 0
    // bool isReal() const;
    class operator Implicit(const v0: double): TScalar;
  end;

function Scalar(const v0, v1: double; const v2: double = 0; const v3: double = 0): TScalar; {$IFDEF USE_INLINE}inline; {$ENDIF}

type
  pInputArray = ^TInputArray;

  TInputArray = record
  public type
    KindFlag = (                         //
      KIND_SHIFT = 16,                   //
      FIXED_TYPE = $8000 shl KIND_SHIFT, //
      FIXED_SIZE = $4000 shl KIND_SHIFT, //
      KIND_MASK = 31 shl KIND_SHIFT,     //

      NONE = 0 shl KIND_SHIFT,              //
      Mat = 1 shl KIND_SHIFT,               //
      MATX = 2 shl KIND_SHIFT,              //
      STD_VECTOR = 3 shl KIND_SHIFT,        //
      STD_VECTOR_VECTOR = 4 shl KIND_SHIFT, //
      STD_VECTOR_MAT = 5 shl KIND_SHIFT,    //
{$IF OPENCV_ABI_COMPATIBILITY < 500}
      expr = 6 shl KIND_SHIFT, // !< removed: https://github.com/opencv/opencv/pull/17046
{$IFEND}
      OPENGL_BUFFER = 7 shl KIND_SHIFT,            //
      CUDA_HOST_MEM = 8 shl KIND_SHIFT,            //
      CUDA_GPU_MAT = 9 shl KIND_SHIFT,             //
      UMAT = 10 shl KIND_SHIFT,                    //
      STD_VECTOR_UMAT = 11 shl KIND_SHIFT,         //
      STD_BOOL_VECTOR = 12 shl KIND_SHIFT,         //
      STD_VECTOR_CUDA_GPU_MAT = 13 shl KIND_SHIFT, //
{$IF OPENCV_ABI_COMPATIBILITY < 500}
      STD_ARRAY = 14 shl KIND_SHIFT, // !< removed: https://github.com/opencv/opencv/issues/18897
{$IFEND}
      STD_ARRAY_MAT = 15 shl KIND_SHIFT);
  public
    class operator Initialize(out Dest: TInputArray); // _InputArray();
    // _InputArray(int _flags, void* _obj);
    class function InputArray(const m: TMat): TInputArray; static; // _InputArray(const Mat& m);
    // _InputArray(const MatExpr& expr);
    // _InputArray(const std::vector<Mat>& vec);
    // _InputArray(const std::vector<bool>& vec);
    // _InputArray(const std::vector<std::vector<bool> >&) = delete;  // not supported
    // _InputArray(const double& val);
    // _InputArray(const cuda::GpuMat& d_mat);
    // _InputArray(const std::vector<cuda::GpuMat>& d_mat_array);
    // _InputArray(const ogl::Buffer& buf);
    // _InputArray(const cuda::HostMem& cuda_mem);
    // _InputArray(const UMat& um);
    // _InputArray(const std::vector<UMat>& umv);
    //
    // Mat getMat(int idx=-1) const;
    // Mat getMat_(int idx=-1) const;
    // UMat getUMat(int idx=-1) const;
    // void getMatVector(std::vector<Mat>& mv) const;
    // void getUMatVector(std::vector<UMat>& umv) const;
    // void getGpuMatVector(std::vector<cuda::GpuMat>& gpumv) const;
    // cuda::GpuMat getGpuMat() const;
    // ogl::Buffer getOGlBuffer() const;
    //
    // int getFlags() const;
    function getObj: Pointer; {$IFDEF USE_INLINE}inline; {$ENDIF} // void* getObj() const;
    // Size getSz() const;
    //
    // _InputArray::KindFlag kind() const;
    // int dims(int i=-1) const;
    // int cols(int i=-1) const;
    // int rows(int i=-1) const;
    // Size size(int i=-1) const;
    // int sizend(int* sz, int i=-1) const;
    // bool sameSize(const _InputArray& arr) const;
    // size_t total(int i=-1) const;
    // int type(int i=-1) const;
    // int depth(int i=-1) const;
    // int channels(int i=-1) const;
    // bool isContinuous(int i=-1) const;
    // bool isSubmatrix(int i=-1) const;
    // bool empty() const;
    // void copyTo(const _OutputArray& arr) const;
    // void copyTo(const _OutputArray& arr, const _InputArray & mask) const;
    // size_t offset(int i=-1) const;
    // size_t step(int i=-1) const;
    function isMat: Bool; {$IFDEF USE_INLINE}inline; {$ENDIF} // bool isMat() const;
    // bool isUMat() const;
    // bool isMatVector() const;
    // bool isUMatVector() const;
    // bool isMatx() const;
    // bool isVector() const;
    // bool isGpuMat() const;
    // bool isGpuMatVector() const;
    class operator Finalize(var Dest: TInputArray); // ~_InputArray();

    class operator Implicit(const m: TMat): TInputArray;
    class operator Implicit(const m: TMatExpr): TInputArray;
    class operator Implicit(const IA: TInputArray): TMat;
  private
{$HINTS OFF}
    flags: int;   // int flags;
    Obj: Pointer; // void* obj;
    sz: TSize;    // Size sz;
{$HINTS ON}
  end;

  pOutputArray = ^TOutputArray;

  TOutputArray = record
  private
    InputArray: TInputArray;
  public type
    DepthMask = (                                  //
      DEPTH_MASK_8U = 1 shl CV_8U,                 //
      DEPTH_MASK_8S = 1 shl CV_8S,                 //
      DEPTH_MASK_16U = 1 shl CV_16U,               //
      DEPTH_MASK_16S = 1 shl CV_16S,               //
      DEPTH_MASK_32S = 1 shl CV_32S,               //
      DEPTH_MASK_32F = 1 shl CV_32F,               //
      DEPTH_MASK_64F = 1 shl CV_64F,               //
      DEPTH_MASK_16F = 1 shl CV_16F,               //
      DEPTH_MASK_ALL = (DEPTH_MASK_64F shl 1) - 1, //
      DEPTH_MASK_ALL_BUT_8S = DEPTH_MASK_ALL and (not DEPTH_MASK_8S), //
      DEPTH_MASK_ALL_16F = (DEPTH_MASK_16F shl 1) - 1, //
      DEPTH_MASK_FLT = DEPTH_MASK_32F + DEPTH_MASK_64F);
  public
    class operator Initialize(out Dest: TOutputArray); // _OutputArray();
    // _OutputArray(int _flags, void* _obj);
    class function OutputArray(const m: TMat): TOutputArray; static; {$IFDEF USE_INLINE}inline; {$ENDIF} // _OutputArray(Mat& m);
    // _OutputArray(std::vector<Mat>& vec);
    // _OutputArray(cuda::GpuMat& d_mat);
    // _OutputArray(std::vector<cuda::GpuMat>& d_mat);
    // _OutputArray(ogl::Buffer& buf);
    // _OutputArray(cuda::HostMem& cuda_mem);
    // _OutputArray(std::vector<bool>& vec) = delete;  // not supported
    // _OutputArray(std::vector<std::vector<bool> >&) = delete;  // not supported
    // _OutputArray(UMat& m);
    // _OutputArray(std::vector<UMat>& vec);
    class operator Finalize(var Dest: TOutputArray); // destructor

    // bool fixedSize() const;
    // bool fixedType() const;
    // bool needed() const;
    // Mat& getMatRef(int i=-1) const;
    // UMat& getUMatRef(int i=-1) const;
    // cuda::GpuMat& getGpuMatRef() const;
    // std::vector<cuda::GpuMat>& getGpuMatVecRef() const;
    // ogl::Buffer& getOGlBufferRef() const;
    // cuda::HostMem& getHostMemRef() const;
    // void create(Size sz, int type, int i=-1, bool allowTransposed=false, _OutputArray::DepthMask fixedDepthMask=static_cast<_OutputArray::DepthMask>(0)) const;
    // void create(int rows, int cols, int type, int i=-1, bool allowTransposed=false, _OutputArray::DepthMask fixedDepthMask=static_cast<_OutputArray::DepthMask>(0)) const;
    // void create(int dims, const int* size, int type, int i=-1, bool allowTransposed=false, _OutputArray::DepthMask fixedDepthMask=static_cast<_OutputArray::DepthMask>(0)) const;
    // void createSameSize(const _InputArray& arr, int mtype) const;
    // void release() const;
    // void clear() const;
    // void setTo(const _InputArray& value, const _InputArray & mask = _InputArray()) const;
    //
    // void assign(const UMat& u) const;
    // void assign(const Mat& m) const;
    //
    // void assign(const std::vector<UMat>& v) const;
    // void assign(const std::vector<Mat>& v) const;
    //
    // void move(UMat& u) const;
    // void move(Mat& m) const;

    class operator Implicit(const m: TMat): TOutputArray;
    class operator Implicit(const OA: TOutputArray): TMat;
  end;

  pInputOutputArray = ^TInputOutputArray;

  TInputOutputArray = record
  private
{$HINTS OFF}
    OutputArray: TOutputArray;
{$HINTS ON}
  public
    class operator Initialize(out Dest: TInputOutputArray); // _InputOutputArray();
    // _InputOutputArray(int _flags, void* _obj);
    procedure InputOutputArray(const m: TMat); {$IFDEF USE_INLINE}inline; {$ENDIF}// _InputOutputArray(Mat& m);
    // _InputOutputArray(std::vector<Mat>& vec);
    // _InputOutputArray(cuda::GpuMat& d_mat);
    // _InputOutputArray(ogl::Buffer& buf);
    // _InputOutputArray(cuda::HostMem& cuda_mem);
    // template<typename _Tp> _InputOutputArray(cudev::GpuMat_<_Tp>& m);
    // template<typename _Tp> _InputOutputArray(std::vector<_Tp>& vec);
    // _InputOutputArray(std::vector<bool>& vec) = delete;  // not supported
    // template<typename _Tp> _InputOutputArray(std::vector<std::vector<_Tp> >& vec);
    // template<typename _Tp> _InputOutputArray(std::vector<Mat_<_Tp> >& vec);
    // template<typename _Tp> _InputOutputArray(Mat_<_Tp>& m);
    // template<typename _Tp> _InputOutputArray(_Tp* vec, int n);
    // template<typename _Tp, int m, int n> _InputOutputArray(Matx<_Tp, m, n>& matx);
    // _InputOutputArray(UMat& m);
    // _InputOutputArray(std::vector<UMat>& vec);
    class operator Finalize(var Dest: TInputOutputArray); // destructor
    //
    // _InputOutputArray(const Mat& m);
    // _InputOutputArray(const std::vector<Mat>& vec);
    // _InputOutputArray(const cuda::GpuMat& d_mat);
    // _InputOutputArray(const std::vector<cuda::GpuMat>& d_mat);
    // _InputOutputArray(const ogl::Buffer& buf);
    // _InputOutputArray(const cuda::HostMem& cuda_mem);
    // template<typename _Tp> _InputOutputArray(const cudev::GpuMat_<_Tp>& m);
    // template<typename _Tp> _InputOutputArray(const std::vector<_Tp>& vec);
    // template<typename _Tp> _InputOutputArray(const std::vector<std::vector<_Tp> >& vec);
    // template<typename _Tp> _InputOutputArray(const std::vector<Mat_<_Tp> >& vec);
    // template<typename _Tp> _InputOutputArray(const Mat_<_Tp>& m);
    // template<typename _Tp> _InputOutputArray(const _Tp* vec, int n);
    // template<typename _Tp, int m, int n> _InputOutputArray(const Matx<_Tp, m, n>& matx);
    // _InputOutputArray(const UMat& m);
    // _InputOutputArray(const std::vector<UMat>& vec);
    //
    // template<typename _Tp, std::size_t _Nm> _InputOutputArray(std::array<_Tp, _Nm>& arr);
    // template<typename _Tp, std::size_t _Nm> _InputOutputArray(const std::array<_Tp, _Nm>& arr);
    // template<std::size_t _Nm> _InputOutputArray(std::array<Mat, _Nm>& arr);
    // template<std::size_t _Nm> _InputOutputArray(const std::array<Mat, _Nm>& arr);
    //
    // template<typename _Tp> static _InputOutputArray rawInOut(std::vector<_Tp>& vec);
    // template<typename _Tp, std::size_t _Nm> _InputOutputArray rawInOut(std::array<_Tp, _Nm>& arr);

    class function noArray: TInputOutputArray; static;
    class operator Implicit(const m: TMat): TInputOutputArray;
    class operator Implicit(const IOA: TInputOutputArray): TMat;
    class operator Implicit(const IOA: TInputOutputArray): TInputArray;
  end;

function noArray(): TInputOutputArray; {$IFDEF USE_INLINE}inline; {$ENDIF}
{$ENDREGION 'mat.hpp'}
//
{$REGION 'core.hpp'}
(* * @brief Swaps two matrices *)
// CV_EXPORTS void swap(Mat& a, Mat& b);
// ?swap@cv@@YAXAEAVMat@1@0@Z
// void cv::swap(class cv::Mat &,class cv::Mat &)
procedure swap(Var a, b: TMat); external opencv_world_dll name '?swap@cv@@YAXAEAVMat@1@0@Z' {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

// CV_EXPORTS void swap( UMat& a, UMat& b );

(* * @brief Computes the source location of an extrapolated pixel.

  The function computes and returns the coordinate of a donor pixel corresponding to the specified
  extrapolated pixel when using the specified extrapolation border mode. For example, if you use
  cv::BORDER_WRAP mode in the horizontal direction, cv::BORDER_REFLECT_101 in the vertical direction and
  want to compute value of the "virtual" pixel Point(-5, 100) in a floating-point image img , it
  looks like:
  @code{.cpp}
  float val = img.at<float>(borderInterpolate(100, img.rows, cv::BORDER_REFLECT_101),
  borderInterpolate(-5, img.cols, cv::BORDER_WRAP));
  @endcode
  Normally, the function is not called directly. It is used inside filtering functions and also in
  copyMakeBorder.
  @param p 0-based coordinate of the extrapolated pixel along one of the axes, likely \<0 or \>= len
  @param len Length of the array along the corresponding axis.
  @param borderType Border type, one of the #BorderTypes, except for #BORDER_TRANSPARENT and
  #BORDER_ISOLATED . When borderType==#BORDER_CONSTANT , the function always returns -1, regardless
  of p and len.

  @sa copyMakeBorder
*)
// CV_EXPORTS_W int borderInterpolate(int p, int len, int borderType);
// ?borderInterpolate@cv@@YAHHHH@Z
function borderInterpolate(p, Len, borderType: int): int; external opencv_world_dll name '?borderInterpolate@cv@@YAHHHH@Z' {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @example samples/cpp/tutorial_code/ImgTrans/copyMakeBorder_demo.cpp
  An example using copyMakeBorder function.
  Check @ref tutorial_copyMakeBorder "the corresponding tutorial" for more details
*)

(* * @brief Forms a border around an image.

  The function copies the source image into the middle of the destination image. The areas to the
  left, to the right, above and below the copied source image will be filled with extrapolated
  pixels. This is not what filtering functions based on it do (they extrapolate pixels on-fly), but
  what other more complex functions, including your own, may do to simplify image boundary handling.

  The function supports the mode when src is already in the middle of dst . In this case, the
  function does not copy src itself but simply constructs the border, for example:

  @code{.cpp}
  // let border be the same in all directions
  int border=2;
  // constructs a larger image to fit both the image and the border
  Mat gray_buf(rgb.rows + border*2, rgb.cols + border*2, rgb.depth());
  // select the middle part of it w/o copying data
  Mat gray(gray_canvas, Rect(border, border, rgb.cols, rgb.rows));
  // convert image from RGB to grayscale
  cvtColor(rgb, gray, COLOR_RGB2GRAY);
  // form a border in-place
  copyMakeBorder(gray, gray_buf, border, border,
  border, border, BORDER_REPLICATE);
  // now do some custom filtering ...
  ...
  @endcode
  @note When the source image is a part (ROI) of a bigger image, the function will try to use the
  pixels outside of the ROI to form a border. To disable this feature and always do extrapolation, as
  if src was not a ROI, use borderType | #BORDER_ISOLATED.

  @param src Source image.
  @param dst Destination image of the same type as src and the size Size(src.cols+left+right,
  src.rows+top+bottom) .
  @param top the top pixels
  @param bottom the bottom pixels
  @param left the left pixels
  @param right Parameter specifying how many pixels in each direction from the source image rectangle
  to extrapolate. For example, top=1, bottom=1, left=1, right=1 mean that 1 pixel-wide border needs
  to be built.
  @param borderType Border type. See borderInterpolate for details.
  @param value Border value if borderType==BORDER_CONSTANT .

  @sa  borderInterpolate
*)

// CV_EXPORTS_W void copyMakeBorder(InputArray src, OutputArray dst,
// int top, int bottom, int left, int right,
// int borderType, const Scalar& value = Scalar() );
// ?copyMakeBorder@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@HHHHHAEBV?$Scalar_@N@1@@Z
// void cv::copyMakeBorder(class cv::_InputArray const &,class cv::_OutputArray const &,int,int,int,int,int,class cv::Scalar_<double> const &)
procedure copyMakeBorder(const Src: TInputArray; Var dst: TOutputArray; top, bottom, left, right, borderType: int; const Scalar: TScalar); overload;
  external opencv_world_dll name '?copyMakeBorder@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@HHHHHAEBV?$Scalar_@N@1@@Z' {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure copyMakeBorder(const Src: TInputArray; Var dst: TOutputArray; top, bottom, left, right, borderType: int); {$IFDEF USE_INLINE}inline; {$ENDIF} overload;

(* * @brief Calculates the weighted sum of two arrays.

  The function addWeighted calculates the weighted sum of two arrays as follows:
  \f[\texttt{dst} (I)= \texttt{saturate} ( \texttt{src1} (I)* \texttt{alpha} +  \texttt{src2} (I)* \texttt{beta} +  \texttt{gamma} )\f]
  where I is a multi-dimensional index of array elements. In case of multi-channel arrays, each
  channel is processed independently.
  The function can be replaced with a matrix expression:
  @code{.cpp}
  dst = src1*alpha + src2*beta + gamma;
  @endcode
  @note Saturation is not applied when the output array has the depth CV_32S. You may even get
  result of an incorrect sign in the case of overflow.
  @param src1 first input array.
  @param alpha weight of the first array elements.
  @param src2 second input array of the same size and channel number as src1.
  @param beta weight of the second array elements.
  @param gamma scalar added to each sum.
  @param dst output array that has the same size and number of channels as the input arrays.
  @param dtype optional depth of the output array; when both input arrays have the same depth, dtype
  can be set to -1, which will be equivalent to src1.depth().
  @sa  add, subtract, scaleAdd, Mat::convertTo
*)
// CV_EXPORTS_W void addWeighted(InputArray src1, double alpha, InputArray src2,
// double beta, double gamma, OutputArray dst, int dtype = -1);
// ?addWeighted@cv@@YAXAEBV_InputArray@1@N0NNAEBV_OutputArray@1@H@Z
// void cv::addWeighted(class cv::_InputArray const &,double,class cv::_InputArray const &,double,double,class cv::_OutputArray const &,int)
procedure addWeighted(src1: TInputArray; alpha: double; src2: TInputArray; beta, gamma: double; dst: TOutputArray; dtype: int = -1); external opencv_world_dll index 3519
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
//
(* * @brief  Inverts every bit of an array.

  The function cv::bitwise_not calculates per-element bit-wise inversion of the input
  array:
  \f[\texttt{dst} (I) =  \neg \texttt{src} (I)\f]
  In case of a floating-point input array, its machine-specific bit
  representation (usually IEEE754-compliant) is used for the operation. In
  case of multi-channel arrays, each channel is processed independently.
  @param src input array.
  @param dst output array that has the same size and type as the input
  array.
  @param mask optional operation mask, 8-bit single channel array, that
  specifies elements of the output array to be changed.
*)
// CV_EXPORTS_W void bitwise_not(InputArray src, OutputArray dst,
// InputArray mask = noArray());
// 3629
// ?bitwise_not@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@0@Z
// void cv::bitwise_not(class cv::_InputArray const &,class cv::_OutputArray const &,class cv::_InputArray const &)
procedure _bitwise_not(Src: TInputArray; dst: TOutputArray; mask: TInputArray { = noArray() } ); external opencv_world_dll index 3629 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure bitwise_not(Src: TInputArray; dst: TOutputArray; mask: TInputArray { = noArray() } ); overload; {$IFDEF USE_INLINE}inline; {$ENDIF} overload;
procedure bitwise_not(Src: TInputArray; dst: TOutputArray); overload; {$IFDEF USE_INLINE}inline; {$ENDIF} overload;

{$ENDREGION 'core.hpp'}
//
{$REGION 'imgcodecs.hpp'}

Type
  ImreadModes = (                    //
    IMREAD_UNCHANGED = -1,           // !< If set, return the loaded image as is (with alpha channel, otherwise it gets cropped). Ignore EXIF orientation.
    IMREAD_GRAYSCALE = 0,            // !< If set, always convert image to the single channel grayscale image (codec internal conversion).
    IMREAD_COLOR = 1,                // !< If set, always convert image to the 3 channel BGR color image.
    IMREAD_ANYDEPTH = 2,             // !< If set, return 16-bit/32-bit image when the input has the corresponding depth, otherwise convert it to 8-bit.
    IMREAD_ANYCOLOR = 4,             // !< If set, the image is read in any possible color format.
    IMREAD_LOAD_GDAL = 8,            // !< If set, use the gdal driver for loading the image.
    IMREAD_REDUCED_GRAYSCALE_2 = 16, // !< If set, always convert image to the single channel grayscale image and the image size reduced 1/2.
    IMREAD_REDUCED_COLOR_2 = 17,     // !< If set, always convert image to the 3 channel BGR color image and the image size reduced 1/2.
    IMREAD_REDUCED_GRAYSCALE_4 = 32, // !< If set, always convert image to the single channel grayscale image and the image size reduced 1/4.
    IMREAD_REDUCED_COLOR_4 = 33,     // !< If set, always convert image to the 3 channel BGR color image and the image size reduced 1/4.
    IMREAD_REDUCED_GRAYSCALE_8 = 64, // !< If set, always convert image to the single channel grayscale image and the image size reduced 1/8.
    IMREAD_REDUCED_COLOR_8 = 65,     // !< If set, always convert image to the 3 channel BGR color image and the image size reduced 1/8.
    IMREAD_IGNORE_ORIENTATION = 128  // !< If set, do not rotate the image according to EXIF's orientation flag.
    );

  (* * @brief Loads an image from a file.

    @anchor imread

    The function imread loads an image from the specified file and returns it. If the image cannot be
    read (because of missing file, improper permissions, unsupported or invalid format), the function
    returns an empty matrix ( Mat::data==NULL ).

    Currently, the following file formats are supported:

    -   Windows bitmaps - \*.bmp, \*.dib (always supported)
    -   JPEG files - \*.jpeg, \*.jpg, \*.jpe (see the *Note* section)
    -   JPEG 2000 files - \*.jp2 (see the *Note* section)
    -   Portable Network Graphics - \*.png (see the *Note* section)
    -   WebP - \*.webp (see the *Note* section)
    -   Portable image format - \*.pbm, \*.pgm, \*.ppm \*.pxm, \*.pnm (always supported)
    -   PFM files - \*.pfm (see the *Note* section)
    -   Sun rasters - \*.sr, \*.ras (always supported)
    -   TIFF files - \*.tiff, \*.tif (see the *Note* section)
    -   OpenEXR Image files - \*.exr (see the *Note* section)
    -   Radiance HDR - \*.hdr, \*.pic (always supported)
    -   Raster and Vector geospatial data supported by GDAL (see the *Note* section)

    @note
    -   The function determines the type of an image by the content, not by the file extension.
    -   In the case of color images, the decoded images will have the channels stored in **B G R** order.
    -   When using IMREAD_GRAYSCALE, the codec's internal grayscale conversion will be used, if available.
    Results may differ to the output of cvtColor()
    -   On Microsoft Windows\* OS and MacOSX\*, the codecs shipped with an OpenCV image (libjpeg,
    libpng, libtiff, and libjasper) are used by default. So, OpenCV can always read JPEGs, PNGs,
    and TIFFs. On MacOSX, there is also an option to use native MacOSX image readers. But beware
    that currently these native image loaders give images with different pixel values because of
    the color management embedded into MacOSX.
    -   On Linux\*, BSD flavors and other Unix-like open-source operating systems, OpenCV looks for
    codecs supplied with an OS image. Install the relevant packages (do not forget the development
    files, for example, "libjpeg-dev", in Debian\* and Ubuntu\* ) to get the codec support or turn
    on the OPENCV_BUILD_3RDPARTY_LIBS flag in CMake.
    -   In the case you set *WITH_GDAL* flag to true in CMake and @ref IMREAD_LOAD_GDAL to load the image,
    then the [GDAL](http://www.gdal.org) driver will be used in order to decode the image, supporting
    the following formats: [Raster](http://www.gdal.org/formats_list.html),
    [Vector](http://www.gdal.org/ogr_formats.html).
    -   If EXIF information is embedded in the image file, the EXIF orientation will be taken into account
    and thus the image will be rotated accordingly except if the flags @ref IMREAD_IGNORE_ORIENTATION
    or @ref IMREAD_UNCHANGED are passed.
    -   Use the IMREAD_UNCHANGED flag to keep the floating point values from PFM image.
    -   By default number of pixels must be less than 2^30. Limit can be set using system
    variable OPENCV_IO_MAX_IMAGE_PIXELS

    @param filename Name of file to be loaded.
    @param flags Flag that can take values of cv::ImreadModes
  *)
  // CV_EXPORTS_W Mat imread(const String & filename, Int flags = IMREAD_COLOR);
  // ?imread@cv@@YA?AVMat@1@AEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z
  // class cv::Mat cv::imread(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,int)
function imread(const filename: CppString; flag: ImreadModes = IMREAD_COLOR): TMat;
  external opencv_world_dll name '?imread@cv@@YA?AVMat@1@AEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z' {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Destroys the specified window.
  The function destroyWindow destroys the window with the given name.
  @param winname Name of the window to be destroyed.
*)
// CV_EXPORTS_W void destroyWindow(const String& winname);

(* * @brief Destroys all of the HighGUI windows.
  The function destroyAllWindows destroys all of the opened HighGUI windows.
*)
// CV_EXPORTS_W void destroyAllWindows();

// CV_EXPORTS_W int startWindowThread();

(* * @brief Similar to #waitKey, but returns full key code.
  @note
  Key code is implementation specific and depends on used backend: QT/GTK/Win32/etc
*)
// CV_EXPORTS_W int waitKeyEx(int delay = 0);

(* * @brief Waits for a pressed key.

  The function waitKey waits for a key event infinitely (when \f$\texttt{delay}\leq 0\f$ ) or for delay
  milliseconds, when it is positive. Since the OS has a minimum time between switching threads, the
  function will not wait exactly delay ms, it will wait at least delay ms, depending on what else is
  running on your computer at that time. It returns the code of the pressed key or -1 if no key was
  pressed before the specified time had elapsed. To check for a key press but not wait for it, use
  #pollKey.

  @note The functions #waitKey and #pollKey are the only methods in HighGUI that can fetch and handle
  GUI events, so one of them needs to be called periodically for normal event processing unless
  HighGUI is used within an environment that takes care of event processing.

  @note The function only works if there is at least one HighGUI window created and the window is
  active. If there are several HighGUI windows, any of them can be active.

  @param delay Delay in milliseconds. 0 is the special value that means "forever".
*)
// CV_EXPORTS_W int waitKey(int delay = 0);
// ?waitKey@cv@@YAHH@Z
// int cv::waitKey(int)
function waitKey(delay: int = 0): int; external opencv_world_dll name '?waitKey@cv@@YAHH@Z' {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Polls for a pressed key.

  The function pollKey polls for a key event without waiting. It returns the code of the pressed key
  or -1 if no key was pressed since the last invocation. To wait until a key was pressed, use #waitKey.

  @note The functions #waitKey and #pollKey are the only methods in HighGUI that can fetch and handle
  GUI events, so one of them needs to be called periodically for normal event processing unless
  HighGUI is used within an environment that takes care of event processing.

  @note The function only works if there is at least one HighGUI window created and the window is
  active. If there are several HighGUI windows, any of them can be active.
*)
// CV_EXPORTS_W int pollKey();

(* * @brief Displays an image in the specified window.

  The function imshow displays an image in the specified window. If the window was created with the
  cv::WINDOW_AUTOSIZE flag, the image is shown with its original size, however it is still limited by the screen resolution.
  Otherwise, the image is scaled to fit the window. The function may scale the image, depending on its depth:

  -   If the image is 8-bit unsigned, it is displayed as is.
  -   If the image is 16-bit unsigned, the pixels are divided by 256. That is, the
  value range [0,255\*256] is mapped to [0,255].
  -   If the image is 32-bit or 64-bit floating-point, the pixel values are multiplied by 255. That is, the
  value range [0,1] is mapped to [0,255].
  -   32-bit integer images are not processed anymore due to ambiguouty of required transform.
  Convert to 8-bit unsigned matrix using a custom preprocessing specific to image's context.

  If window was created with OpenGL support, cv::imshow also support ogl::Buffer , ogl::Texture2D and
  cuda::GpuMat as input.

  If the window was not created before this function, it is assumed creating a window with cv::WINDOW_AUTOSIZE.

  If you need to show an image that is bigger than the screen resolution, you will need to call namedWindow("", WINDOW_NORMAL) before the imshow.

  @note This function should be followed by a call to cv::waitKey or cv::pollKey to perform GUI
  housekeeping tasks that are necessary to actually show the given image and make the window respond
  to mouse and keyboard events. Otherwise, it won't display the image and the window might lock up.
  For example, **waitKey(0)** will display the window infinitely until any keypress (it is suitable
  for image display). **waitKey(25)** will display a frame and wait approximately 25 ms for a key
  press (suitable for displaying a video frame-by-frame). To remove the window, use cv::destroyWindow.

  @note

  [__Windows Backend Only__] Pressing Ctrl+C will copy the image to the clipboard.

  [__Windows Backend Only__] Pressing Ctrl+S will show a dialog to save the image.

  @param winname Name of the window.
  @param mat Image to be shown.
*)
// CV_EXPORTS_W void imshow(const String & winname, InputArray Mat);
// ?imshow@cv@@YAXAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@AEBV_InputArray@1@@Z
// void cv::imshow(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,class cv::_InputArray const &)
procedure imshow(const winname: CppString; Mat: TInputArray); overload; external opencv_world_dll index 5268
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

{$ENDREGION 'imgcodecs.hpp'}
//
{$REGION 'highgui.hpp'}

Type
  WindowFlags = (                //
    WINDOW_NORMAL = $00000000,   // !< the user can resize the window (no constraint) / also use to switch a fullscreen window to a normal size.
    WINDOW_AUTOSIZE = $00000001, // !< the user cannot resize the window, the size is constrainted by the image displayed.
    WINDOW_OPENGL = $00001000,   // !< window with opengl support.

    WINDOW_FULLSCREEN = 1,           // !< change the window to fullscreen.
    WINDOW_FREERATIO = $00000100,    // !< the image expends as much as it can (no ratio constraint).
    WINDOW_KEEPRATIO = $00000000,    // !< the ratio of the image is respected.
    WINDOW_GUI_EXPANDED = $00000000, // !< status bar and tool bar
    WINDOW_GUI_NORMAL = $00000010    // !< old fashious way
    );

  (* * @brief Creates a window.

    The function namedWindow creates a window that can be used as a placeholder for images and
    trackbars. Created windows are referred to by their names.

    If a window with the same name already exists, the function does nothing.

    You can call cv::destroyWindow or cv::destroyAllWindows to close the window and de-allocate any associated
    memory usage. For a simple program, you do not really have to call these functions because all the
    resources and windows of the application are closed automatically by the operating system upon exit.

    @note

    Qt backend supports additional flags:
    -   **WINDOW_NORMAL or WINDOW_AUTOSIZE:** WINDOW_NORMAL enables you to resize the
    window, whereas WINDOW_AUTOSIZE adjusts automatically the window size to fit the
    displayed image (see imshow ), and you cannot change the window size manually.
    -   **WINDOW_FREERATIO or WINDOW_KEEPRATIO:** WINDOW_FREERATIO adjusts the image
    with no respect to its ratio, whereas WINDOW_KEEPRATIO keeps the image ratio.
    -   **WINDOW_GUI_NORMAL or WINDOW_GUI_EXPANDED:** WINDOW_GUI_NORMAL is the old way to draw the window
    without statusbar and toolbar, whereas WINDOW_GUI_EXPANDED is a new enhanced GUI.
    By default, flags == WINDOW_AUTOSIZE | WINDOW_KEEPRATIO | WINDOW_GUI_EXPANDED

    @param winname Name of the window in the window caption that may be used as a window identifier.
    @param flags Flags of the window. The supported flags are: (cv::WindowFlags)
  *)
  // CV_EXPORTS_W void namedWindow(const String& winname, int flags = WINDOW_AUTOSIZE);
  // ?namedWindow@cv@@YAXAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z
  // void cv::namedWindow(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,int)
procedure namedWindow(const winname: CppString; flags: WindowFlags = WINDOW_AUTOSIZE); overload; external opencv_world_dll index 5721
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

//
(* * @brief Creates a trackbar and attaches it to the specified window.

  The function createTrackbar creates a trackbar (a slider or range control) with the specified name
  and range, assigns a variable value to be a position synchronized with the trackbar and specifies
  the callback function onChange to be called on the trackbar position change. The created trackbar is
  displayed in the specified window winname.

  @note

  [__Qt Backend Only__] winname can be empty if the trackbar should be attached to the
  control panel.

  Clicking the label of each trackbar enables editing the trackbar values manually.

  @param trackbarname Name of the created trackbar.
  @param winname Name of the window that will be used as a parent of the created trackbar.
  @param value Optional pointer to an integer variable whose value reflects the position of the
  slider. Upon creation, the slider position is defined by this variable.
  @param count Maximal position of the slider. The minimal position is always 0.
  @param onChange Pointer to the function to be called every time the slider changes position. This
  function should be prototyped as void Foo(int,void\ * );
  , where the first parameter is the trackbar position and the second parameter is the user data(see the next parameter).If the callback is the NULL Pointer, no callbacks are called,
  but only value is updated.@param userdata user data that is passed as is to the callback.It can be used to handle trackbar events without using global variables.
*)
// CV_EXPORTS int createTrackbar(const String& trackbarname, const String& winname,
// int* value, int count,
// TrackbarCallback onChange = 0,
// void* userdata = 0);
// 4302
// ?createTrackbar@cv@@YAHAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@0PEAHHP6AXHPEAX@Z2@Z
// int cv::createTrackbar(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,int *,int,void (*)(int,void *),void *)
Type
  TTrackbarCallback = procedure(pos: int; userdata: Pointer);
function createTrackbar(const trackbarname: CppString; const winname: CppString; value: pInt; count: int; onChange: TTrackbarCallback = nil; userdata: Pointer = nil): int;
  external opencv_world_dll index 4302{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Moves the window to the specified position

  @param winname Name of the window.
  @param x The new x-coordinate of the window.
  @param y The new y-coordinate of the window.
*)
// CV_EXPORTS_W void moveWindow(const String& winname, int x, int y);
// 5691
// ?moveWindow@cv@@YAXAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@HH@Z
// void cv::moveWindow(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,int,int)
procedure moveWindow(const winname: CppString; x, y: int); external opencv_world_dll index 5691{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Destroys the specified window.
  The function destroyWindow destroys the window with the given name.
  @param winname Name of the window to be destroyed.
*)
// CV_EXPORTS_W void destroyWindow(const String& winname);
// 4411
// ?destroyWindow@cv@@YAXAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@@Z
// void cv::destroyWindow(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &)
procedure destroyWindow(const winname: CppString); external opencv_world_dll index 4411{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

{$ENDREGION 'highgui.hpp'}
//
{$REGION 'imgproc.hpp'}

type
  LineTypes = (  //
    FILLED = -1, //
    LINE_4 = 4,  // !< 4-connected line
    LINE_8 = 8,  // !< 8-connected line
    LINE_AA = 16 // !< antialiased line
    );

  HersheyFonts = (                   //
    FONT_HERSHEY_SIMPLEX = 0,        // !< normal size sans-serif font
    FONT_HERSHEY_PLAIN = 1,          // !< small size sans-serif font
    FONT_HERSHEY_DUPLEX = 2,         // !< normal size sans-serif font (more complex than FONT_HERSHEY_SIMPLEX)
    FONT_HERSHEY_COMPLEX = 3,        // !< normal size serif font
    FONT_HERSHEY_TRIPLEX = 4,        // !< normal size serif font (more complex than FONT_HERSHEY_COMPLEX)
    FONT_HERSHEY_COMPLEX_SMALL = 5,  // !< smaller version of FONT_HERSHEY_COMPLEX
    FONT_HERSHEY_SCRIPT_SIMPLEX = 6, // !< hand-writing style font
    FONT_HERSHEY_SCRIPT_COMPLEX = 7, // !< more complex variant of FONT_HERSHEY_SCRIPT_SIMPLEX
    FONT_ITALIC = 16                 // !< flag for italic font
    );

  ColorConversionCodes = (           //
    COLOR_BGR2BGRA = 0,              // !< add alpha channel to RGB or BGR image
    COLOR_RGB2RGBA = COLOR_BGR2BGRA, //
    //
    COLOR_BGRA2BGR = 1,              // !< remove alpha channel from RGB or BGR image
    COLOR_RGBA2RGB = COLOR_BGRA2BGR, //
    //
    COLOR_BGR2RGBA = 2,              // !< convert between RGB and BGR color spaces (with or without alpha channel)
    COLOR_RGB2BGRA = COLOR_BGR2RGBA, //
    //
    COLOR_RGBA2BGR = 3,              //
    COLOR_BGRA2RGB = COLOR_RGBA2BGR, //
    //
    COLOR_BGR2RGB = 4,             //
    COLOR_RGB2BGR = COLOR_BGR2RGB, //
    //
    COLOR_BGRA2RGBA = 5,               //
    COLOR_RGBA2BGRA = COLOR_BGRA2RGBA, //
    //
    COLOR_BGR2GRAY = 6,                // !< convert between RGB/BGR and grayscale, @ref color_convert_rgb_gray "color conversions"
    COLOR_RGB2GRAY = 7,                //
    COLOR_GRAY2BGR = 8,                //
    COLOR_GRAY2RGB = COLOR_GRAY2BGR,   //
    COLOR_GRAY2BGRA = 9,               //
    COLOR_GRAY2RGBA = COLOR_GRAY2BGRA, //
    COLOR_BGRA2GRAY = 10,              //
    COLOR_RGBA2GRAY = 11,              //
    //
    COLOR_BGR2BGR565 = 12,  // !< convert between RGB/BGR and BGR565 (16-bit images)
    COLOR_RGB2BGR565 = 13,  //
    COLOR_BGR5652BGR = 14,  //
    COLOR_BGR5652RGB = 15,  //
    COLOR_BGRA2BGR565 = 16, //
    COLOR_RGBA2BGR565 = 17, //
    COLOR_BGR5652BGRA = 18, //
    COLOR_BGR5652RGBA = 19, //
    //
    COLOR_GRAY2BGR565 = 20, // !< convert between grayscale to BGR565 (16-bit images)
    COLOR_BGR5652GRAY = 21, //
    //
    COLOR_BGR2BGR555 = 22,  // !< convert between RGB/BGR and BGR555 (16-bit images)
    COLOR_RGB2BGR555 = 23,  //
    COLOR_BGR5552BGR = 24,  //
    COLOR_BGR5552RGB = 25,  //
    COLOR_BGRA2BGR555 = 26, //
    COLOR_RGBA2BGR555 = 27, //
    COLOR_BGR5552BGRA = 28, //
    COLOR_BGR5552RGBA = 29, //
    //
    COLOR_GRAY2BGR555 = 30, // !< convert between grayscale and BGR555 (16-bit images)
    COLOR_BGR5552GRAY = 31, //
    //
    COLOR_BGR2XYZ = 32, // !< convert RGB/BGR to CIE XYZ, @ref color_convert_rgb_xyz "color conversions"
    COLOR_RGB2XYZ = 33, //
    COLOR_XYZ2BGR = 34, //
    COLOR_XYZ2RGB = 35, //
    //
    COLOR_BGR2YCrCb = 36, // !< convert RGB/BGR to luma-chroma (aka YCC), @ref color_convert_rgb_ycrcb "color conversions"
    COLOR_RGB2YCrCb = 37, //
    COLOR_YCrCb2BGR = 38, //
    COLOR_YCrCb2RGB = 39, //
    //
    COLOR_BGR2HSV = 40, // !< convert RGB/BGR to HSV (hue saturation value) with H range 0..180 if 8 bit image, @ref color_convert_rgb_hsv "color conversions"
    COLOR_RGB2HSV = 41, //
    //
    COLOR_BGR2Lab = 44, // !< convert RGB/BGR to CIE Lab, @ref color_convert_rgb_lab "color conversions"
    COLOR_RGB2Lab = 45, //
    //
    COLOR_BGR2Luv = 50, // !< convert RGB/BGR to CIE Luv, @ref color_convert_rgb_luv "color conversions"
    COLOR_RGB2Luv = 51, //
    COLOR_BGR2HLS = 52, // !< convert RGB/BGR to HLS (hue lightness saturation) with H range 0..180 if 8 bit image, @ref color_convert_rgb_hls "color conversions"
    COLOR_RGB2HLS = 53, //
    //
    COLOR_HSV2BGR = 54, // !< backward conversions HSV to RGB/BGR with H range 0..180 if 8 bit image
    COLOR_HSV2RGB = 55, //
    //
    COLOR_Lab2BGR = 56, //
    COLOR_Lab2RGB = 57, //
    COLOR_Luv2BGR = 58, //
    COLOR_Luv2RGB = 59, //
    COLOR_HLS2BGR = 60, // !< backward conversions HLS to RGB/BGR with H range 0..180 if 8 bit image
    COLOR_HLS2RGB = 61, //
    //
    COLOR_BGR2HSV_FULL = 66, // !< convert RGB/BGR to HSV (hue saturation value) with H range 0..255 if 8 bit image, @ref color_convert_rgb_hsv "color conversions"
    COLOR_RGB2HSV_FULL = 67, //
    COLOR_BGR2HLS_FULL = 68, // !< convert RGB/BGR to HLS (hue lightness saturation) with H range 0..255 if 8 bit image, @ref color_convert_rgb_hls "color conversions"
    COLOR_RGB2HLS_FULL = 69, //

    COLOR_HSV2BGR_FULL = 70, // !< backward conversions HSV to RGB/BGR with H range 0..255 if 8 bit image
    COLOR_HSV2RGB_FULL = 71, //
    COLOR_HLS2BGR_FULL = 72, // !< backward conversions HLS to RGB/BGR with H range 0..255 if 8 bit image
    COLOR_HLS2RGB_FULL = 73, //
    //
    COLOR_LBGR2Lab = 74, //
    COLOR_LRGB2Lab = 75, //
    COLOR_LBGR2Luv = 76, //
    COLOR_LRGB2Luv = 77, //
    //
    COLOR_Lab2LBGR = 78, //
    COLOR_Lab2LRGB = 79, //
    COLOR_Luv2LBGR = 80, //
    COLOR_Luv2LRGB = 81, //
    //
    COLOR_BGR2YUV = 82, // !< convert between RGB/BGR and YUV
    COLOR_RGB2YUV = 83, //
    COLOR_YUV2BGR = 84, //
    COLOR_YUV2RGB = 85, //
    //
    // ! YUV 4:2:0 family to RGB
    COLOR_YUV2RGB_NV12 = 90,                 //
    COLOR_YUV2BGR_NV12 = 91,                 //
    COLOR_YUV2RGB_NV21 = 92,                 //
    COLOR_YUV2BGR_NV21 = 93,                 //
    COLOR_YUV420sp2RGB = COLOR_YUV2RGB_NV21, //
    COLOR_YUV420sp2BGR = COLOR_YUV2BGR_NV21, //

    COLOR_YUV2RGBA_NV12 = 94,                  //
    COLOR_YUV2BGRA_NV12 = 95,                  //
    COLOR_YUV2RGBA_NV21 = 96,                  //
    COLOR_YUV2BGRA_NV21 = 97,                  //
    COLOR_YUV420sp2RGBA = COLOR_YUV2RGBA_NV21, //
    COLOR_YUV420sp2BGRA = COLOR_YUV2BGRA_NV21, //
    //
    COLOR_YUV2RGB_YV12 = 98,                 //
    COLOR_YUV2BGR_YV12 = 99,                 //
    COLOR_YUV2RGB_IYUV = 100,                //
    COLOR_YUV2BGR_IYUV = 101,                //
    COLOR_YUV2RGB_I420 = COLOR_YUV2RGB_IYUV, //
    COLOR_YUV2BGR_I420 = COLOR_YUV2BGR_IYUV, //
    COLOR_YUV420p2RGB = COLOR_YUV2RGB_YV12,  //
    COLOR_YUV420p2BGR = COLOR_YUV2BGR_YV12,  //
    //
    COLOR_YUV2RGBA_YV12 = 102,                 //
    COLOR_YUV2BGRA_YV12 = 103,                 //
    COLOR_YUV2RGBA_IYUV = 104,                 //
    COLOR_YUV2BGRA_IYUV = 105,                 //
    COLOR_YUV2RGBA_I420 = COLOR_YUV2RGBA_IYUV, //
    COLOR_YUV2BGRA_I420 = COLOR_YUV2BGRA_IYUV, //
    COLOR_YUV420p2RGBA = COLOR_YUV2RGBA_YV12,  //
    COLOR_YUV420p2BGRA = COLOR_YUV2BGRA_YV12,  //
    //
    COLOR_YUV2GRAY_420 = 106,                 //
    COLOR_YUV2GRAY_NV21 = COLOR_YUV2GRAY_420, //
    COLOR_YUV2GRAY_NV12 = COLOR_YUV2GRAY_420, //
    COLOR_YUV2GRAY_YV12 = COLOR_YUV2GRAY_420, //
    COLOR_YUV2GRAY_IYUV = COLOR_YUV2GRAY_420, //
    COLOR_YUV2GRAY_I420 = COLOR_YUV2GRAY_420, //
    COLOR_YUV420sp2GRAY = COLOR_YUV2GRAY_420, //
    COLOR_YUV420p2GRAY = COLOR_YUV2GRAY_420,  //
    //
    // ! YUV 4:2:2 family to RGB
    COLOR_YUV2RGB_UYVY = 107, //
    COLOR_YUV2BGR_UYVY = 108, //
    // COLOR_YUV2RGB_VYUY = 109,
    // COLOR_YUV2BGR_VYUY = 110,
    COLOR_YUV2RGB_Y422 = COLOR_YUV2RGB_UYVY, //
    COLOR_YUV2BGR_Y422 = COLOR_YUV2BGR_UYVY, //
    COLOR_YUV2RGB_UYNV = COLOR_YUV2RGB_UYVY, //
    COLOR_YUV2BGR_UYNV = COLOR_YUV2BGR_UYVY, //
    //
    COLOR_YUV2RGBA_UYVY = 111, //
    COLOR_YUV2BGRA_UYVY = 112, //
    // COLOR_YUV2RGBA_VYUY = 113,
    // COLOR_YUV2BGRA_VYUY = 114,
    COLOR_YUV2RGBA_Y422 = COLOR_YUV2RGBA_UYVY, //
    COLOR_YUV2BGRA_Y422 = COLOR_YUV2BGRA_UYVY, //
    COLOR_YUV2RGBA_UYNV = COLOR_YUV2RGBA_UYVY, //
    COLOR_YUV2BGRA_UYNV = COLOR_YUV2BGRA_UYVY, //
    //
    COLOR_YUV2RGB_YUY2 = 115,                //
    COLOR_YUV2BGR_YUY2 = 116,                //
    COLOR_YUV2RGB_YVYU = 117,                //
    COLOR_YUV2BGR_YVYU = 118,                //
    COLOR_YUV2RGB_YUYV = COLOR_YUV2RGB_YUY2, //
    COLOR_YUV2BGR_YUYV = COLOR_YUV2BGR_YUY2, //
    COLOR_YUV2RGB_YUNV = COLOR_YUV2RGB_YUY2, //
    COLOR_YUV2BGR_YUNV = COLOR_YUV2BGR_YUY2, //
    //
    COLOR_YUV2RGBA_YUY2 = 119,                 //
    COLOR_YUV2BGRA_YUY2 = 120,                 //
    COLOR_YUV2RGBA_YVYU = 121,                 //
    COLOR_YUV2BGRA_YVYU = 122,                 //
    COLOR_YUV2RGBA_YUYV = COLOR_YUV2RGBA_YUY2, //
    COLOR_YUV2BGRA_YUYV = COLOR_YUV2BGRA_YUY2, //
    COLOR_YUV2RGBA_YUNV = COLOR_YUV2RGBA_YUY2, //
    COLOR_YUV2BGRA_YUNV = COLOR_YUV2BGRA_YUY2, //
    //
    COLOR_YUV2GRAY_UYVY = 123, //
    COLOR_YUV2GRAY_YUY2 = 124, //
    // CV_YUV2GRAY_VYUY    = CV_YUV2GRAY_UYVY,
    COLOR_YUV2GRAY_Y422 = COLOR_YUV2GRAY_UYVY, //
    COLOR_YUV2GRAY_UYNV = COLOR_YUV2GRAY_UYVY, //
    COLOR_YUV2GRAY_YVYU = COLOR_YUV2GRAY_YUY2, //
    COLOR_YUV2GRAY_YUYV = COLOR_YUV2GRAY_YUY2, //
    COLOR_YUV2GRAY_YUNV = COLOR_YUV2GRAY_YUY2, //
    //
    // ! alpha premultiplication
    COLOR_RGBA2mRGBA = 125, //
    COLOR_mRGBA2RGBA = 126, //
    //
    // ! RGB to YUV 4:2:0 family
    COLOR_RGB2YUV_I420 = 127,                //
    COLOR_BGR2YUV_I420 = 128,                //
    COLOR_RGB2YUV_IYUV = COLOR_RGB2YUV_I420, //
    COLOR_BGR2YUV_IYUV = COLOR_BGR2YUV_I420, //
    //
    COLOR_RGBA2YUV_I420 = 129,                 //
    COLOR_BGRA2YUV_I420 = 130,                 //
    COLOR_RGBA2YUV_IYUV = COLOR_RGBA2YUV_I420, //
    COLOR_BGRA2YUV_IYUV = COLOR_BGRA2YUV_I420, //
    COLOR_RGB2YUV_YV12 = 131,                  //
    COLOR_BGR2YUV_YV12 = 132,                  //
    COLOR_RGBA2YUV_YV12 = 133,                 //
    COLOR_BGRA2YUV_YV12 = 134,                 //
    //
    // ! Demosaicing
    COLOR_BayerBG2BGR = 46, //
    COLOR_BayerGB2BGR = 47, //
    COLOR_BayerRG2BGR = 48, //
    COLOR_BayerGR2BGR = 49, //
    //
    COLOR_BayerBG2RGB = COLOR_BayerRG2BGR, //
    COLOR_BayerGB2RGB = COLOR_BayerGR2BGR, //
    COLOR_BayerRG2RGB = COLOR_BayerBG2BGR, //
    COLOR_BayerGR2RGB = COLOR_BayerGB2BGR, //
    //
    COLOR_BayerBG2GRAY = 86, //
    COLOR_BayerGB2GRAY = 87, //
    COLOR_BayerRG2GRAY = 88, //
    COLOR_BayerGR2GRAY = 89, //
    //
    // ! Demosaicing using Variable Number of Gradients
    COLOR_BayerBG2BGR_VNG = 62, //
    COLOR_BayerGB2BGR_VNG = 63, //
    COLOR_BayerRG2BGR_VNG = 64, //
    COLOR_BayerGR2BGR_VNG = 65, //
    //
    COLOR_BayerBG2RGB_VNG = COLOR_BayerRG2BGR_VNG, //
    COLOR_BayerGB2RGB_VNG = COLOR_BayerGR2BGR_VNG, //
    COLOR_BayerRG2RGB_VNG = COLOR_BayerBG2BGR_VNG, //
    COLOR_BayerGR2RGB_VNG = COLOR_BayerGB2BGR_VNG, //
    //
    // ! Edge-Aware Demosaicing
    COLOR_BayerBG2BGR_EA = 135, //
    COLOR_BayerGB2BGR_EA = 136, //
    COLOR_BayerRG2BGR_EA = 137, //
    COLOR_BayerGR2BGR_EA = 138, //
    //
    COLOR_BayerBG2RGB_EA = COLOR_BayerRG2BGR_EA, //
    COLOR_BayerGB2RGB_EA = COLOR_BayerGR2BGR_EA, //
    COLOR_BayerRG2RGB_EA = COLOR_BayerBG2BGR_EA, //
    COLOR_BayerGR2RGB_EA = COLOR_BayerGB2BGR_EA, //
    //
    // ! Demosaicing with alpha channel
    COLOR_BayerBG2BGRA = 139, //
    COLOR_BayerGB2BGRA = 140, //
    COLOR_BayerRG2BGRA = 141, //
    COLOR_BayerGR2BGRA = 142, //
    //
    COLOR_BayerBG2RGBA = COLOR_BayerRG2BGRA, //
    COLOR_BayerGB2RGBA = COLOR_BayerGR2BGRA, //
    COLOR_BayerRG2RGBA = COLOR_BayerBG2BGRA, //
    COLOR_BayerGR2RGBA = COLOR_BayerGB2BGRA, //
    //
    COLOR_COLORCVT_MAX = 143 //
    );

  // ! type of the threshold operation
  // ! ![threshold types](pics/threshold.png)
  ThresholdTypes = (       //
    THRESH_BINARY = 0,     // !< \f[\texttt{dst} (x,y) =  \fork{\texttt{maxval}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
    THRESH_BINARY_INV = 1, // !< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{maxval}}{otherwise}\f]
    THRESH_TRUNC = 2,      // !< \f[\texttt{dst} (x,y) =  \fork{\texttt{threshold}}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
    THRESH_TOZERO = 3,     // !< \f[\texttt{dst} (x,y) =  \fork{\texttt{src}(x,y)}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{0}{otherwise}\f]
    THRESH_TOZERO_INV = 4, // !< \f[\texttt{dst} (x,y) =  \fork{0}{if \(\texttt{src}(x,y) > \texttt{thresh}\)}{\texttt{src}(x,y)}{otherwise}\f]
    THRESH_MASK = 7,       //
    THRESH_OTSU = 8,       // !< flag, use Otsu algorithm to choose the optimal threshold value
    THRESH_TRIANGLE = 16   // !< flag, use Triangle algorithm to choose the optimal threshold value
    );

  // ! adaptive threshold algorithm
  // ! @see adaptiveThreshold
  AdaptiveThresholdTypes = ( //
    (* * the threshold value \f$T(x,y)\f$ is a mean of the \f$\texttt{blockSize} \times
      \texttt{blockSize}\f$ neighborhood of \f$(x, y)\f$ minus C *)
    ADAPTIVE_THRESH_MEAN_C = 0,
    (* * the threshold value \f$T(x, y)\f$ is a weighted sum (cross-correlation with a Gaussian
      window) of the \f$\texttt{blockSize} \times \texttt{blockSize}\f$ neighborhood of \f$(x, y)\f$
      minus C . The default sigma (standard deviation) is used for the specified blockSize . See
      #getGaussianKernel *)
    ADAPTIVE_THRESH_GAUSSIAN_C = 1);

  // ! shape of the structuring element
  MorphShapes = (    //
    MORPH_RECT = 0,  // !< a rectangular structuring element:  \f[E_{ij}=1\f]
    MORPH_CROSS = 1, // !< a cross-shaped structuring element:
    // !< \f[E_{ij} = \begin{cases} 1 & \texttt{if } {i=\texttt{anchor.y } {or } {j=\texttt{anchor.x}}} \\0 & \texttt{otherwise} \end{cases}\f]
    MORPH_ELLIPSE = 2 // !< an elliptic structuring element, that is, a filled ellipse inscribed
    // !< into the rectangle Rect(0, 0, esize.width, 0.esize.height)
    );

  (* * @brief Draws a text string.

    The function cv::putText renders the specified text string in the image. Symbols that cannot be rendered
    using the specified font are replaced by question marks. See #getTextSize for a text rendering code
    example.

    @param img Image.
    @param text Text string to be drawn.
    @param org Bottom-left corner of the text string in the image.
    @param fontFace Font type, see #HersheyFonts.
    @param fontScale Font scale factor that is multiplied by the font-specific base size.
    @param color Text color.
    @param thickness Thickness of the lines used to draw a text.
    @param lineType Line type. See #LineTypes
    @param bottomLeftOrigin When true, the image data origin is at the bottom-left corner. Otherwise,
    it is at the top-left corner.
  *)
  // CV_EXPORTS_W void putText( InputOutputArray img, const String& text, Point org,
  // int fontFace, double fontScale, Scalar color,
  // int thickness = 1, int lineType = LINE_8,
  // bool bottomLeftOrigin = false );
  // 5972
  // ?putText@cv@@YAXAEBV_InputOutputArray@1@AEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@V?$Point_@H@1@HNV?$Scalar_@N@1@HH_N@Z
  // void cv::putText(class cv::_InputOutputArray const &,class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const &,class cv::Point_<int>,int,double,class cv::Scalar_<double>,int,int,bool)
procedure _putText(img: TInputOutputArray;

  const text: CppString; org: UInt64; fontFace: HersheyFonts; fontScale: double; color: TScalar; thickness: int = 1; lineType: LineTypes = LINE_8; bottomLeftOrigin: Bool = false);
  external opencv_world_dll index 5972
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure putText(img: TInputOutputArray;

  const text: CppString; org: TPoint; fontFace: HersheyFonts; fontScale: double; color: TScalar; thickness: int = 1; lineType: LineTypes = LINE_8; bottomLeftOrigin: Bool = false);
{$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Blurs an image using the normalized box filter.

  The function smooths an image using the kernel:

  \f[\texttt{K} =  \frac{1}{\texttt{ksize.width*ksize.height}} \begin{bmatrix} 1 & 1 & 1 &  \cdots & 1 & 1  \\ 1 & 1 & 1 &  \cdots & 1 & 1  \\ \hdotsfor{6} \\ 1 & 1 & 1 &  \cdots & 1 & 1  \\ \end{bmatrix}\f]

  The call `blur(src, dst, ksize, anchor, borderType)` is equivalent to `boxFilter(src, dst, src.type(), ksize,
  anchor, true, borderType)`.

  @param src input image; it can have any number of channels, which are processed independently, but
  the depth should be CV_8U, CV_16U, CV_16S, CV_32F or CV_64F.
  @param dst output image of the same size and type as src.
  @param ksize blurring kernel size.
  @param anchor anchor point; default value Point(-1,-1) means that the anchor is at the kernel
  center.
  @param borderType border mode used to extrapolate pixels outside of the image, see #BorderTypes. #BORDER_WRAP is not supported.
  @sa  boxFilter, bilateralFilter, GaussianBlur, medianBlur
*)
// CV_EXPORTS_W void blur( InputArray src, OutputArray dst,
// Size ksize, Point anchor = Point(-1,-1),
// int borderType = BORDER_DEFAULT );
// 3649
// ?blur@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@V?$Size_@H@1@V?$Point_@H@1@H@Z
// void cv::blur(class cv::_InputArray const &,class cv::_OutputArray const &,class cv::Size_<int>,class cv::Point_<int>,int)

procedure _blur(Src: TInputArray; dst: TOutputArray; ksize: UInt64 { TSize }; anchor: UInt64 { TPoint  = Point(-1, -1) }; borderType: int { = BORDER_DEFAULT } ); external opencv_world_dll index 3649
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure blur(Src: TInputArray; dst: TOutputArray; ksize: TSize); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
procedure blur(Src: TInputArray; dst: TOutputArray; ksize: TSize; anchor: TPoint; borderType: BorderTypes = BORDER_DEFAULT); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Blurs an image using a Gaussian filter.

  The function convolves the source image with the specified Gaussian kernel. In-place filtering is
  supported.

  @param src input image; the image can have any number of channels, which are processed
  independently, but the depth should be CV_8U, CV_16U, CV_16S, CV_32F or CV_64F.
  @param dst output image of the same size and type as src.
  @param ksize Gaussian kernel size. ksize.width and ksize.height can differ but they both must be
  positive and odd. Or, they can be zero's and then they are computed from sigma.
  @param sigmaX Gaussian kernel standard deviation in X direction.
  @param sigmaY Gaussian kernel standard deviation in Y direction; if sigmaY is zero, it is set to be
  equal to sigmaX, if both sigmas are zeros, they are computed from ksize.width and ksize.height,
  respectively (see #getGaussianKernel for details); to fully control the result regardless of
  possible future modifications of all this semantics, it is recommended to specify all of ksize,
  sigmaX, and sigmaY.
  @param borderType pixel extrapolation method, see #BorderTypes. #BORDER_WRAP is not supported.

  @sa  sepFilter2D, filter2D, blur, boxFilter, bilateralFilter, medianBlur
*)
// CV_EXPORTS_W void GaussianBlur( InputArray src, OutputArray dst, Size ksize,
// double sigmaX, double sigmaY = 0,
// int borderType = BORDER_DEFAULT );
// 3370
// ?GaussianBlur@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@V?$Size_@H@1@NNH@Z
// void cv::GaussianBlur(class cv::_InputArray const &,class cv::_OutputArray const &,class cv::Size_<int>,double,double,int)
procedure _GaussianBlur(Src: TInputArray; dst: TOutputArray; ksize: UInt64 { TSize }; sigmaX: double; sigmaY: double { = 0 }; borderType: int { = BORDER_DEFAULT }
  ); external opencv_world_dll index 3370 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure GaussianBlur(Src: TInputArray; dst: TOutputArray; ksize: TSize; sigmaX: double; sigmaY: double = 0; borderType: BorderTypes = BORDER_DEFAULT); {$IFDEF USE_INLINE}inline;
{$ENDIF}
//
(* * @brief Applies the bilateral filter to an image.

  The function applies bilateral filtering to the input image, as described in
  http://www.dai.ed.ac.uk/CVonline/LOCAL_COPIES/MANDUCHI1/Bilateral_Filtering.html
  bilateralFilter can reduce unwanted noise very well while keeping edges fairly sharp. However, it is
  very slow compared to most filters.

  _Sigma values_: For simplicity, you can set the 2 sigma values to be the same. If they are small (\<
  10), the filter will not have much effect, whereas if they are large (\> 150), they will have a very
  strong effect, making the image look "cartoonish".

  _Filter size_: Large filters (d \> 5) are very slow, so it is recommended to use d=5 for real-time
  applications, and perhaps d=9 for offline applications that need heavy noise filtering.

  This filter does not work inplace.
  @param src Source 8-bit or floating-point, 1-channel or 3-channel image.
  @param dst Destination image of the same size and type as src .
  @param d Diameter of each pixel neighborhood that is used during filtering. If it is non-positive,
  it is computed from sigmaSpace.
  @param sigmaColor Filter sigma in the color space. A larger value of the parameter means that
  farther colors within the pixel neighborhood (see sigmaSpace) will be mixed together, resulting
  in larger areas of semi-equal color.
  @param sigmaSpace Filter sigma in the coordinate space. A larger value of the parameter means that
  farther pixels will influence each other as long as their colors are close enough (see sigmaColor
  ). When d\>0, it specifies the neighborhood size regardless of sigmaSpace. Otherwise, d is
  proportional to sigmaSpace.
  @param borderType border mode used to extrapolate pixels outside of the image, see #BorderTypes
*)
// CV_EXPORTS_W void bilateralFilter( InputArray src, OutputArray dst, int d,
// double sigmaColor, double sigmaSpace,
// int borderType = BORDER_DEFAULT );
// 3615
// ?bilateralFilter@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@HNNH@Z
// void cv::bilateralFilter(class cv::_InputArray const &,class cv::_OutputArray const &,int,double,double,int)
procedure bilateralFilter(Src: TInputArray; dst: TOutputArray; d: int; sigmaColor, sigmaSpace: double; borderType: BorderTypes = BORDER_DEFAULT); external opencv_world_dll index 3615
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
//
(* * @brief Blurs an image using the median filter.

  The function smoothes an image using the median filter with the \f$\texttt{ksize} \times
  \texttt{ksize}\f$ aperture. Each channel of a multi-channel image is processed independently.
  In-place operation is supported.

  @note The median filter uses #BORDER_REPLICATE internally to cope with border pixels, see #BorderTypes

  @param src input 1-, 3-, or 4-channel image; when ksize is 3 or 5, the image depth should be
  CV_8U, CV_16U, or CV_32F, for larger aperture sizes, it can only be CV_8U.
  @param dst destination array of the same size and type as src.
  @param ksize aperture linear size; it must be odd and greater than 1, for example: 3, 5, 7 ...
  @sa  bilateralFilter, blur, boxFilter, GaussianBlur
*)
// CV_EXPORTS_W void medianBlur( InputArray src, OutputArray dst, int ksize );
// 5628
// ?medianBlur@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@H@Z
// void cv::medianBlur(class cv::_InputArray const &,class cv::_OutputArray const &,int)
procedure medianBlur(Src: TInputArray; dst: TOutputArray; ksize: int); external opencv_world_dll index 5628
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
//
(* * @brief Applies a fixed-level threshold to each array element.

  The function applies fixed-level thresholding to a multiple-channel array. The function is typically
  used to get a bi-level (binary) image out of a grayscale image ( #compare could be also used for
  this purpose) or for removing a noise, that is, filtering out pixels with too small or too large
  values. There are several types of thresholding supported by the function. They are determined by
  type parameter.

  Also, the special values #THRESH_OTSU or #THRESH_TRIANGLE may be combined with one of the
  above values. In these cases, the function determines the optimal threshold value using the Otsu's
  or Triangle algorithm and uses it instead of the specified thresh.

  @note Currently, the Otsu's and Triangle methods are implemented only for 8-bit single-channel images.

  @param src input array (multiple-channel, 8-bit or 32-bit floating point).
  @param dst output array of the same size  and type and the same number of channels as src.
  @param thresh threshold value.
  @param maxval maximum value to use with the #THRESH_BINARY and #THRESH_BINARY_INV thresholding
  types.
  @param type thresholding type (see #ThresholdTypes).
  @return the computed threshold value if Otsu's or Triangle methods used.

  @sa  adaptiveThreshold, findContours, compare, min, max
*)
// CV_EXPORTS_W double threshold( InputArray src, OutputArray dst,
// double thresh, double maxval, int type );
// 6609
// ?threshold@cv@@YANAEBV_InputArray@1@AEBV_OutputArray@1@NNH@Z
// double cv::threshold(class cv::_InputArray const &,class cv::_OutputArray const &,double,double,int)
function threshold(Src: TInputArray; dst: TOutputArray; thresh, maxval: double; &type: int): double; external opencv_world_dll index 6609 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
//
(* * @brief Applies an adaptive threshold to an array.

  The function transforms a grayscale image to a binary image according to the formulae:
  -   **THRESH_BINARY**
  \f[dst(x,y) =  \fork{\texttt{maxValue}}{if \(src(x,y) > T(x,y)\)}{0}{otherwise}\f]
  -   **THRESH_BINARY_INV**
  \f[dst(x,y) =  \fork{0}{if \(src(x,y) > T(x,y)\)}{\texttt{maxValue}}{otherwise}\f]
  where \f$T(x,y)\f$ is a threshold calculated individually for each pixel (see adaptiveMethod parameter).

  The function can process the image in-place.

  @param src Source 8-bit single-channel image.
  @param dst Destination image of the same size and the same type as src.
  @param maxValue Non-zero value assigned to the pixels for which the condition is satisfied
  @param adaptiveMethod Adaptive thresholding algorithm to use, see #AdaptiveThresholdTypes.
  The #BORDER_REPLICATE | #BORDER_ISOLATED is used to process boundaries.
  @param thresholdType Thresholding type that must be either #THRESH_BINARY or #THRESH_BINARY_INV,
  see #ThresholdTypes.
  @param blockSize Size of a pixel neighborhood that is used to calculate a threshold value for the
  pixel: 3, 5, 7, and so on.
  @param C Constant subtracted from the mean or weighted mean (see the details below). Normally, it
  is positive but may be zero or negative as well.

  @sa  threshold, blur, GaussianBlur
*)
// CV_EXPORTS_W void adaptiveThreshold( InputArray src, OutputArray dst,
// double maxValue, int adaptiveMethod,
// int thresholdType, int blockSize, double C );
// 3475
// ?adaptiveThreshold@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@NHHHN@Z
// void cv::adaptiveThreshold(class cv::_InputArray const &,class cv::_OutputArray const &,double,int,int,int,double)
procedure _adaptiveThreshold(Src: TInputArray; dst: TOutputArray; maxValue: double; adaptiveMethod: int; thresholdType: int; blockSize: int; c: double); external opencv_world_dll index 3475
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure adaptiveThreshold(Src: TInputArray; dst: TOutputArray; maxValue: double; adaptiveMethod: AdaptiveThresholdTypes; thresholdType: ThresholdTypes; blockSize: int; c: double);
{$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Converts an image from one color space to another.

  The function converts an input image from one color space to another. In case of a transformation
  to-from RGB color space, the order of the channels should be specified explicitly (RGB or BGR). Note
  that the default color format in OpenCV is often referred to as RGB but it is actually BGR (the
  bytes are reversed). So the first byte in a standard (24-bit) color image will be an 8-bit Blue
  component, the second byte will be Green, and the third byte will be Red. The fourth, fifth, and
  sixth bytes would then be the second pixel (Blue, then Green, then Red), and so on.

  The conventional ranges for R, G, and B channel values are:
  -   0 to 255 for CV_8U images
  -   0 to 65535 for CV_16U images
  -   0 to 1 for CV_32F images

  In case of linear transformations, the range does not matter. But in case of a non-linear
  transformation, an input RGB image should be normalized to the proper value range to get the correct
  results, for example, for RGB \f$\rightarrow\f$ L\*u\*v\* transformation. For example, if you have a
  32-bit floating-point image directly converted from an 8-bit image without any scaling, then it will
  have the 0..255 value range instead of 0..1 assumed by the function. So, before calling #cvtColor ,
  you need first to scale the image down:
  @code
  img *= 1./255;
  cvtColor(img, img, COLOR_BGR2Luv);
  @endcode
  If you use #cvtColor with 8-bit images, the conversion will have some information lost. For many
  applications, this will not be noticeable but it is recommended to use 32-bit images in applications
  that need the full range of colors or that convert an image before an operation and then convert
  back.

  If conversion adds the alpha channel, its value will set to the maximum of corresponding channel
  range: 255 for CV_8U, 65535 for CV_16U, 1 for CV_32F.

  @param src input image: 8-bit unsigned, 16-bit unsigned ( CV_16UC... ), or single-precision
  floating-point.
  @param dst output image of the same size and depth as src.
  @param code color space conversion code (see #ColorConversionCodes).
  @param dstCn number of channels in the destination image; if the parameter is 0, the number of the
  channels is derived automatically from src and code.

  @see @ref imgproc_color_conversions
*)
// CV_EXPORTS_W void cvtColor( InputArray src, OutputArray dst, int code, int dstCn = 0 );
// 4338
// ?cvtColor@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@HH@Z
// void cv::cvtColor(class cv::_InputArray const &,class cv::_OutputArray const &,int,int)
procedure _cvtColor(Src: TInputArray; dst: TOutputArray; code: int; dstCn: int = 0); external opencv_world_dll index 4338 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure cvtColor(Src: TInputArray; dst: TOutputArray; code: ColorConversionCodes; dstCn: int = 0);
{$IFDEF USE_INLINE}inline; {$ENDIF}
//
// ! returns "magic" border value for erosion and dilation. It is automatically transformed to Scalar::all(-DBL_MAX) for dilation.
function morphologyDefaultBorderValue(): TScalar; {$IFDEF USE_INLINE}inline; {$ENDIF} { return Scalar::all(DBL_MAX); }
//
(* * @brief Returns a structuring element of the specified size and shape for morphological operations.

  The function constructs and returns the structuring element that can be further passed to #erode,
  #dilate or #morphologyEx. But you can also construct an arbitrary binary mask yourself and use it as
  the structuring element.

  @param shape Element shape that could be one of #MorphShapes
  @param ksize Size of the structuring element.
  @param anchor Anchor position within the element. The default value \f$(-1, -1)\f$ means that the
  anchor is at the center. Note that only the shape of a cross-shaped element depends on the anchor
  position. In other cases the anchor just regulates how much the result of the morphological
  operation is shifted.
*)
// CV_EXPORTS_W Mat getStructuringElement(int shape, Size ksize, Point anchor = Point(-1,-1));
// 5125
// ?getStructuringElement@cv@@YA?AVMat@1@HV?$Size_@H@1@V?$Point_@H@1@@Z
// class cv::Mat cv::getStructuringElement(int,class cv::Size_<int>,class cv::Point_<int>)
function _getStructuringElement(shape: int; ksize: UInt64; anchor: UInt64): TMat; external opencv_world_dll index 5125 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
function getStructuringElement(shape: MorphShapes; ksize: TSize): TMat; overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
function getStructuringElement(shape: MorphShapes; ksize: TSize; anchor: TPoint): TMat; overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Erodes an image by using a specific structuring element.

  The function erodes the source image using the specified structuring element that determines the
  shape of a pixel neighborhood over which the minimum is taken:

  \f[\texttt{dst} (x,y) =  \min _{(x',y'):  \, \texttt{element} (x',y') \ne0 } \texttt{src} (x+x',y+y')\f]

  The function supports the in-place mode. Erosion can be applied several ( iterations ) times. In
  case of multi-channel images, each channel is processed independently.

  @param src input image; the number of channels can be arbitrary, but the depth should be one of
  CV_8U, CV_16U, CV_16S, CV_32F or CV_64F.
  @param dst output image of the same size and type as src.
  @param kernel structuring element used for erosion; if `element=Mat()`, a `3 x 3` rectangular
  structuring element is used. Kernel can be created using #getStructuringElement.
  @param anchor position of the anchor within the element; default value (-1, -1) means that the
  anchor is at the element center.
  @param iterations number of times erosion is applied.
  @param borderType pixel extrapolation method, see #BorderTypes. #BORDER_WRAP is not supported.
  @param borderValue border value in case of a constant border
  @sa  dilate, morphologyEx, getStructuringElement
*)
// CV_EXPORTS_W void erode( InputArray src, OutputArray dst, InputArray kernel,
// Point anchor = Point(-1,-1), int iterations = 1,
// int borderType = BORDER_CONSTANT,
// const Scalar& borderValue = morphologyDefaultBorderValue() );
// 4631
// ?erode@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@0V?$Point_@H@1@HHAEBV?$Scalar_@N@1@@Z
// void cv::erode(class cv::_InputArray const &,class cv::_OutputArray const &,class cv::_InputArray const &,class cv::Point_<int>,int,int,class cv::Scalar_<double> const &)
procedure _erode(Src: TInputArray; dst: TOutputArray; kernel: TInputArray; anchor: UInt64 { Point = Point(-1,-1) }; iterations: int { = 1 }; borderType: int { = BORDER_CONSTANT };
  const borderValue: TScalar { = morphologyDefaultBorderValue() } ); external opencv_world_dll index 4631 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT }; const borderValue: TScalar { = morphologyDefaultBorderValue() } ); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT } ); overload;
{$IFDEF USE_INLINE}inline; {$ENDIF}
procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 } ); overload;
{$IFDEF USE_INLINE}inline; {$ENDIF}
procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) } ); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Dilates an image by using a specific structuring element.

  The function dilates the source image using the specified structuring element that determines the
  shape of a pixel neighborhood over which the maximum is taken:
  \f[\texttt{dst} (x,y) =  \max _{(x',y'):  \, \texttt{element} (x',y') \ne0 } \texttt{src} (x+x',y+y')\f]

  The function supports the in-place mode. Dilation can be applied several ( iterations ) times. In
  case of multi-channel images, each channel is processed independently.

  @param src input image; the number of channels can be arbitrary, but the depth should be one of
  CV_8U, CV_16U, CV_16S, CV_32F or CV_64F.
  @param dst output image of the same size and type as src.
  @param kernel structuring element used for dilation; if elemenat=Mat(), a 3 x 3 rectangular
  structuring element is used. Kernel can be created using #getStructuringElement
  @param anchor position of the anchor within the element; default value (-1, -1) means that the
  anchor is at the element center.
  @param iterations number of times dilation is applied.
  @param borderType pixel extrapolation method, see #BorderTypes. #BORDER_WRAP is not suported.
  @param borderValue border value in case of a constant border
  @sa  erode, morphologyEx, getStructuringElement
*)
// CV_EXPORTS_W void dilate( InputArray src, OutputArray dst, InputArray kernel,
// Point anchor = Point(-1,-1), int iterations = 1,
// int borderType = BORDER_CONSTANT,
// const Scalar& borderValue = morphologyDefaultBorderValue());
// 4492
// ?dilate@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@0V?$Point_@H@1@HHAEBV?$Scalar_@N@1@@Z
// void cv::dilate(class cv::_InputArray const &,class cv::_OutputArray const &,class cv::_InputArray const &,class cv::Point_<int>,int,int,class cv::Scalar_<double> const &)
procedure _dilate(Src: TInputArray; dst: TOutputArray; kernel: TInputArray; anchor: UInt64 { Point= Point(-1,-1) }; iterations: int { = 1 }; borderType: int { = BORDER_CONSTANT };
  const borderValue: TScalar { = morphologyDefaultBorderValue() } ); external opencv_world_dll index 4492 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT }; const borderValue: TScalar { = morphologyDefaultBorderValue() } ); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT } ); overload;
{$IFDEF USE_INLINE}inline; {$ENDIF}
procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 } ); overload;
{$IFDEF USE_INLINE}inline; {$ENDIF}
procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) } ); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
//
(* * @brief Equalizes the histogram of a grayscale image.

  The function equalizes the histogram of the input image using the following algorithm:

  - Calculate the histogram \f$H\f$ for src .
  - Normalize the histogram so that the sum of histogram bins is 255.
  - Compute the integral of the histogram:
  \f[H'_i =  \sum _{0  \le j < i} H(j)\f]
  - Transform the image using \f$H'\f$ as a look-up table: \f$\texttt{dst}(x,y) = H'(\texttt{src}(x,y))\f$

  The algorithm normalizes the brightness and increases the contrast of the image.

  @param src Source 8-bit single channel image.
  @param dst Destination image of the same size and type as src .
*)
// CV_EXPORTS_W void equalizeHist( InputArray src, OutputArray dst );
// 4624
// ?equalizeHist@cv@@YAXAEBV_InputArray@1@AEBV_OutputArray@1@@Z
// void cv::equalizeHist(class cv::_InputArray const &,class cv::_OutputArray const &)
procedure equalizeHist(Src: TInputArray; dst: TOutputArray); external opencv_world_dll index 4624 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Draws a simple or thick elliptic arc or fills an ellipse sector.

  The function cv::ellipse with more parameters draws an ellipse outline, a filled ellipse, an elliptic
  arc, or a filled ellipse sector. The drawing code uses general parametric form.
  A piecewise-linear curve is used to approximate the elliptic arc
  boundary. If you need more control of the ellipse rendering, you can retrieve the curve using
  #ellipse2Poly and then render it with #polylines or fill it with #fillPoly. If you use the first
  variant of the function and want to draw the whole ellipse, not an arc, pass `startAngle=0` and
  `endAngle=360`. If `startAngle` is greater than `endAngle`, they are swapped. The figure below explains
  the meaning of the parameters to draw the blue arc.

  ![Parameters of Elliptic Arc](pics/ellipse.svg)

  @param img Image.
  @param center Center of the ellipse.
  @param axes Half of the size of the ellipse main axes.
  @param angle Ellipse rotation angle in degrees.
  @param startAngle Starting angle of the elliptic arc in degrees.
  @param endAngle Ending angle of the elliptic arc in degrees.
  @param color Ellipse color.
  @param thickness Thickness of the ellipse arc outline, if positive. Otherwise, this indicates that
  a filled ellipse sector is to be drawn.
  @param lineType Type of the ellipse boundary. See #LineTypes
  @param shift Number of fractional bits in the coordinates of the center and values of axes.
*)
// CV_EXPORTS_W void ellipse(InputOutputArray img, Point center, Size axes,
// double angle, double startAngle, double endAngle,
// const Scalar& color, int thickness = 1,
// int lineType = LINE_8, int shift = 0);
// 4577
// ?ellipse2Poly@cv@@YAXV?$Point_@H@1@V?$Size_@H@1@HHHHAEAV?$vector@V?$Point_@H@cv@@V?$allocator@V?$Point_@H@cv@@@std@@@std@@@Z
// void cv::ellipse2Poly(class cv::Point_<int>,class cv::Size_<int>,int,int,int,int,class std::vector<class cv::Point_<int>,class std::allocator<class cv::Point_<int> > > &)
procedure ellipse(img: TInputOutputArray; center: TPoint; axes: TSize; angle, startAngle, endAngle: double; const color: TScalar; thickness: int = 1; lineType: int = int(LINE_8); shift: int = 0);
  external opencv_world_dll index 4577 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

(* * @brief Draws a circle.

  The function cv::circle draws a simple or filled circle with a given center and radius.
  @param img Image where the circle is drawn.
  @param center Center of the circle.
  @param radius Radius of the circle.
  @param color Circle color.
  @param thickness Thickness of the circle outline, if positive. Negative values, like #FILLED,
  mean that a filled circle is to be drawn.
  @param lineType Type of the circle boundary. See #LineTypes
  @param shift Number of fractional bits in the coordinates of the center and in the radius value.
*)
// CV_EXPORTS_W void circle(InputOutputArray img, Point center, int radius,
// const Scalar& color, int thickness = 1,
// int lineType = LINE_8, int shift = 0);
// 3795
// ?circle@cv@@YAXAEBV_InputOutputArray@1@V?$Point_@H@1@HAEBV?$Scalar_@N@1@HHH@Z
// void cv::circle(class cv::_InputOutputArray const &,class cv::Point_<int>,int,class cv::Scalar_<double> const &,int,int,int)
procedure circle(img: TInputOutputArray; center: TPoint; radius: int; const color: TScalar; thickness: int = 1; lineType: int = int(LINE_8); shift: int = 0); external opencv_world_dll index 3795
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

{$ENDREGION 'imgproc.hpp'}
//
{$REGION 'objectdetect.hpp'}

Type
  (* * @example samples/cpp/facedetect.cpp
    This program demonstrates usage of the Cascade classifier class
    \image html Cascade_Classifier_Tutorial_Result_Haar.jpg "Sample screenshot" width=321 height=254
  *)
  (* * @brief Cascade classifier class for object detection. *)

  pCascadeClassifier = ^TCascadeClassifier;

  TCascadeClassifier = record
  private
{$HINTS OFF}
    Dummy: array [0 .. 1] of UInt64;
{$HINTS ON}
  public
    class operator Initialize(out Dest: TCascadeClassifier); // CV_WRAP CascadeClassifier();
    (* * @brief Loads a classifier from a file.
      @param filename Name of the file from which the classifier is loaded. *)
    // CV_WRAP CascadeClassifier(const String& filename);
    class operator Finalize(var Dest: TCascadeClassifier); // ~CascadeClassifier();
    (* * @brief Checks whether the classifier has been loaded. *)
    // CV_WRAP bool empty() const;
    (* * @brief Loads a classifier from a file.

      @param filename Name of the file from which the classifier is loaded. The file may contain an old
      HAAR classifier trained by the haartraining application or a new cascade classifier trained by the
      traincascade application.
    *)
    function load(const filename: String): Bool; overload; {$IFDEF USE_INLINE}inline; {$ENDIF}// CV_WRAP bool load( const String& filename );
    function load(const filename: CvStdString): Bool; overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
    (* * @brief Reads a classifier from a FileStorage node.
      @note The file may contain a new cascade classifier (trained traincascade application) only. *)
    // CV_WRAP bool read( const FileNode& node );

    (* * @brief Detects objects of different sizes in the input image. The detected objects are returned as a list of rectangles.

      @param image Matrix of the type CV_8U containing an image where objects are detected.
      @param objects Vector of rectangles where each rectangle contains the detected object, the
      rectangles may be partially outside the original image.
      @param scaleFactor Parameter specifying how much the image size is reduced at each image scale.
      @param minNeighbors Parameter specifying how many neighbors each candidate rectangle should have
      to retain it.
      @param flags Parameter with the same meaning for an old cascade as in the function
      cvHaarDetectObjects. It is not used for a new cascade.
      @param minSize Minimum possible object size. Objects smaller than that are ignored.
      @param maxSize Maximum possible object size. Objects larger than that are ignored. If `maxSize == minSize` model is evaluated on single scale.

      The function is parallelized with the TBB library.

      @note
      -   (Python) A face detection example using cascade classifiers can be found at
      opencv_source_code/samples/python/facedetect.py
    *)
    procedure detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double = 1.1; minNeighbors: int = 3; flags: int = 0); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}
    procedure detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double; minNeighbors: int; flags: int; const minSize: TSize { = Size() } ); overload;
{$IFDEF USE_INLINE}inline;
{$ENDIF}
    procedure detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double; minNeighbors: int; flags: int; const minSize: TSize;
      const maxSize: TSize { = Size() } ); overload;
{$IFDEF USE_INLINE}inline; {$ENDIF}

    // CV_WRAP void detectMultiScale( InputArray image,
    // CV_OUT std::vector<Rect>& objects,
    // double scaleFactor = 1.1,
    // int minNeighbors = 3, int flags = 0,
    // Size minSize = Size(),
    // Size maxSize = Size() );

    (* * @overload
      @param image Matrix of the type CV_8U containing an image where objects are detected.
      @param objects Vector of rectangles where each rectangle contains the detected object, the
      rectangles may be partially outside the original image.
      @param numDetections Vector of detection numbers for the corresponding objects. An object's number
      of detections is the number of neighboring positively classified rectangles that were joined
      together to form the object.
      @param scaleFactor Parameter specifying how much the image size is reduced at each image scale.
      @param minNeighbors Parameter specifying how many neighbors each candidate rectangle should have
      to retain it.
      @param flags Parameter with the same meaning for an old cascade as in the function
      cvHaarDetectObjects. It is not used for a new cascade.
      @param minSize Minimum possible object size. Objects smaller than that are ignored.
      @param maxSize Maximum possible object size. Objects larger than that are ignored. If `maxSize == minSize` model is evaluated on single scale.
    *)
    // CV_WRAP_AS(detectMultiScale2) void detectMultiScale( InputArray image,
    // CV_OUT std::vector<Rect>& objects,
    // CV_OUT std::vector<int>& numDetections,
    // double scaleFactor=1.1,
    // int minNeighbors=3, int flags=0,
    // Size minSize=Size(),
    // Size maxSize=Size() );

    (* * @overload
      This function allows you to retrieve the final stage decision certainty of classification.
      For this, one needs to set `outputRejectLevels` on true and provide the `rejectLevels` and `levelWeights` parameter.
      For each resulting detection, `levelWeights` will then contain the certainty of classification at the final stage.
      This value can then be used to separate strong from weaker classifications.

      A code sample on how to use it efficiently can be found below:
      @code
      Mat img;
      vector<double> weights;
      vector<int> levels;
      vector<Rect> detections;
      CascadeClassifier model("/path/to/your/model.xml");
      model.detectMultiScale(img, detections, levels, weights, 1.1, 3, 0, Size(), Size(), true);
      cerr << "Detection " << detections[0] << " with weight " << weights[0] << endl;
      @endcode
    *)
    // CV_WRAP_AS(detectMultiScale3) void detectMultiScale( InputArray image,
    // CV_OUT std::vector<Rect>& objects,
    // CV_OUT std::vector<int>& rejectLevels,
    // CV_OUT std::vector<double>& levelWeights,
    // double scaleFactor = 1.1,
    // int minNeighbors = 3, int flags = 0,
    // Size minSize = Size(),
    // Size maxSize = Size(),
    // bool outputRejectLevels = false );

    // CV_WRAP bool isOldFormatCascade() const;
    // CV_WRAP Size getOriginalWindowSize() const;
    // CV_WRAP int getFeatureType() const;
    // void* getOldCascade();

    // CV_WRAP static bool convert(const String& oldcascade, const String& newcascade);

    // void setMaskGenerator(const Ptr<BaseCascadeClassifier::MaskGenerator>& maskGenerator);
    // Ptr<BaseCascadeClassifier::MaskGenerator> getMaskGenerator();

    // Ptr<BaseCascadeClassifier> cc;
  end;

{$ENDREGION 'objectdetect.hpp'}
  //
{$REGION 'fast_math.hpp'}

  (* * @brief Rounds floating-point number to the nearest integer

    @param value floating-point number. If the value is outside of INT_MIN ... INT_MAX range, the
    result is not defined.
  *)
  // CV_INLINE int cvRound( double value )
  // 4320
  // ?cvRound@@YAHAEBUsoftdouble@cv@@@Z
  // int cvRound(struct cv::softdouble const &)
function cvRound(value: double): int; external opencv_world_dll index 4320 {$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

{$ENDREGION 'fast_math.hpp'}
//
{$REGION 'videoio.hpp'}

type
  VideoCaptureAPIs = (           //
    CAP_ANY = 0,                 // !< Auto detect == 0
    CAP_VFW = 200,               // !< Video For Windows (obsolete, removed)
    CAP_V4L = 200,               // !< V4L/V4L2 capturing support
    CAP_V4L2 = CAP_V4L,          // !< Same as CAP_V4L
    CAP_FIREWIRE = 300,          // !< IEEE 1394 drivers
    CAP_FIREWARE = CAP_FIREWIRE, // !< Same value as CAP_FIREWIRE
    CAP_IEEE1394 = CAP_FIREWIRE, // !< Same value as CAP_FIREWIRE
    CAP_DC1394 = CAP_FIREWIRE,   // !< Same value as CAP_FIREWIRE
    CAP_CMU1394 = CAP_FIREWIRE,  // !< Same value as CAP_FIREWIRE
    CAP_QT = 500,                // !< QuickTime (obsolete, removed)
    CAP_UNICAP = 600,            // !< Unicap drivers (obsolete, removed)
    CAP_DSHOW = 700,             // !< DirectShow (via videoInput)
    CAP_PVAPI = 800,             // !< PvAPI, Prosilica GigE SDK
    CAP_OPENNI = 900,            // !< OpenNI (for Kinect)
    CAP_OPENNI_ASUS = 910,       // !< OpenNI (for Asus Xtion)
    CAP_ANDROID = 1000,          // !< Android - not used
    CAP_XIAPI = 1100,            // !< XIMEA Camera API
    CAP_AVFOUNDATION = 1200,     // !< AVFoundation framework for iOS (OS X Lion will have the same API)
    CAP_GIGANETIX = 1300,        // !< Smartek Giganetix GigEVisionSDK
    CAP_MSMF = 1400,             // !< Microsoft Media Foundation (via videoInput)
    CAP_WINRT = 1410,            // !< Microsoft Windows Runtime using Media Foundation
    CAP_INTELPERC = 1500,        // !< RealSense (former Intel Perceptual Computing SDK)
    CAP_REALSENSE = 1500,        // !< Synonym for CAP_INTELPERC
    CAP_OPENNI2 = 1600,          // !< OpenNI2 (for Kinect)
    CAP_OPENNI2_ASUS = 1610,     // !< OpenNI2 (for Asus Xtion and Occipital Structure sensors)
    CAP_OPENNI2_ASTRA = 1620,    // !< OpenNI2 (for Orbbec Astra)
    CAP_GPHOTO2 = 1700,          // !< gPhoto2 connection
    CAP_GSTREAMER = 1800,        // !< GStreamer
    CAP_FFMPEG = 1900,           // !< Open and record video file or stream using the FFMPEG library
    CAP_IMAGES = 2000,           // !< OpenCV Image Sequence (e.g. img_%02d.jpg)
    CAP_ARAVIS = 2100,           // !< Aravis SDK
    CAP_OPENCV_MJPEG = 2200,     // !< Built-in OpenCV MotionJPEG codec
    CAP_INTEL_MFX = 2300,        // !< Intel MediaSDK
    CAP_XINE = 2400,             // !< XINE engine (Linux)
    CAP_UEYE = 2500              // !< uEye Camera API
    );

  pVideoCapture = ^TVideoCapture;

  TVideoCapture = record
  public
    (* * @brief Default constructor
      @note In @ref videoio_c "C API", when you finished working with video, release CvCapture structure with
      cvReleaseCapture(), or use Ptr\<CvCapture\> that calls cvReleaseCapture() automatically in the
      destructor.
    *)
    class operator Initialize(out Dest: TVideoCapture); // CV_WRAP VideoCapture();

    (* * @overload
      @brief  Opens a video file or a capturing device or an IP video stream for video capturing with API Preference

      @param filename it can be:
      - name of video file (eg. `video.avi`)
      - or image sequence (eg. `img_%02d.jpg`, which will read samples like `img_00.jpg, img_01.jpg, img_02.jpg, ...`)
      - or URL of video stream (eg. `protocol://host:port/script_name?script_params|auth`)
      - or GStreamer pipeline string in gst-launch tool format in case if GStreamer is used as backend
      Note that each video stream or IP camera feed has its own URL scheme. Please refer to the
      documentation of source stream to know the right URL.
      @param apiPreference preferred Capture API backends to use. Can be used to enforce a specific reader
      implementation if multiple are available: e.g. cv::CAP_FFMPEG or cv::CAP_IMAGES or cv::CAP_DSHOW.

      @sa cv::VideoCaptureAPIs
    *)

    // CV_WRAP explicit VideoCapture(const String & filename, int apiPreference = CAP_ANY);

    (* * @overload
      @brief Opens a video file or a capturing device or an IP video stream for video capturing with API Preference and parameters

      The `params` parameter allows to specify extra parameters encoded as pairs `(paramId_1, paramValue_1, paramId_2, paramValue_2, ...)`.
      See cv::VideoCaptureProperties
    *)
    // CV_WRAP explicit VideoCapture(const String & filename, int apiPreference, const std: : vector<int> & params);

    (* * @overload
      @brief  Opens a camera for video capturing

      @param index id of the video capturing device to open. To open default camera using default backend just pass 0.
      (to backward compatibility usage of camera_id + domain_offset (CAP_* ) is valid when apiPreference is CAP_ANY)
      @param apiPreference preferred Capture API backends to use. Can be used to enforce a specific reader
      implementation if multiple are available: e.g. cv::CAP_DSHOW or cv::CAP_MSMF or cv::CAP_V4L.

      @sa cv::VideoCaptureAPIs
    *)
    // CV_WRAP explicit VideoCapture(int index, int apiPreference = CAP_ANY);

    (* * @overload
      @brief Opens a camera for video capturing with API Preference and parameters

      The `params` parameter allows to specify extra parameters encoded as pairs `(paramId_1, paramValue_1, paramId_2, paramValue_2, ...)`.
      See cv::VideoCaptureProperties
    *)
    // CV_WRAP explicit VideoCapture(int index, int apiPreference, const std: : vector<int> & params);

    (* * @brief Default destructor

      The method first calls VideoCapture::release to close the already opened file or camera.
    *)
    class operator Finalize(var Dest: TVideoCapture); // virtual ~ VideoCapture();

    (* * @brief  Opens a video file or a capturing device or an IP video stream for video capturing.

      @overload

      Parameters are same as the constructor VideoCapture(const String& filename, int apiPreference = CAP_ANY)
      @return `true` if the file has been successfully opened

      The method first calls VideoCapture::release to close the already opened file or camera.
    *)
    // CV_WRAP virtual Bool open(const String & filename, int apiPreference = CAP_ANY);

    (* * @brief  Opens a camera for video capturing

      @overload

      The `params` parameter allows to specify extra parameters encoded as pairs `(paramId_1, paramValue_1, paramId_2, paramValue_2, ...)`.
      See cv::VideoCaptureProperties

      @return `true` if the file has been successfully opened

      The method first calls VideoCapture::release to close the already opened file or camera.
    *)
    // CV_WRAP virtual Bool open(const String & filename, int apiPreference, const std: : vector<int> & params);

    (* * @brief  Opens a camera for video capturing

      @overload

      Parameters are same as the constructor VideoCapture(int index, int apiPreference = CAP_ANY)
      @return `true` if the camera has been successfully opened.

      The method first calls VideoCapture::release to close the already opened file or camera.
    *)
    function open(const index: int; const apiPreference: VideoCaptureAPIs = CAP_ANY): Bool; {$IFDEF USE_INLINE}inline; {$ENDIF}
    // CV_WRAP virtual Bool open(int index, int apiPreference = CAP_ANY);

    (* * @brief Returns true if video capturing has been initialized already.

      @overload

      The `params` parameter allows to specify extra parameters encoded as pairs `(paramId_1, paramValue_1, paramId_2, paramValue_2, ...)`.
      See cv::VideoCaptureProperties

      @return `true` if the camera has been successfully opened.

      The method first calls VideoCapture::release to close the already opened file or camera.
    *)
    // CV_WRAP virtual Bool open(int index, int apiPreference, const std: : vector<int> & params);

    (* * @brief Returns true if video capturing has been initialized already.

      If the previous call to VideoCapture constructor or VideoCapture::open() succeeded, the method returns
      true.
    *)
    function isOpened: Bool; {$IFDEF USE_INLINE}inline; {$ENDIF}// CV_WRAP virtual Bool isOpened()  const;

    (* * @brief Closes video file or capturing device.

      The method is automatically called by subsequent VideoCapture::open and by VideoCapture
      destructor.

      The C function also deallocates memory and clears \*capture pointer.
    *)
    // CV_WRAP virtual void release();

    (* * @brief Grabs the next frame from video file or capturing device.

      @return `true` (non-zero) in the case of success.

      The method/function grabs the next frame from video file or camera and returns true (non-zero) in
      the case of success.

      The primary use of the function is in multi-camera environments, especially when the cameras do not
      have hardware synchronization. That is, you call VideoCapture::grab() for each camera and after that
      call the slower method VideoCapture::retrieve() to decode and get frame from each camera. This way
      the overhead on demosaicing or motion jpeg decompression etc. is eliminated and the retrieved frames
      from different cameras will be closer in time.

      Also, when a connected camera is multi-head (for example, a stereo camera or a Kinect device), the
      correct way of retrieving data from it is to call VideoCapture::grab() first and then call
      VideoCapture::retrieve() one or more times with different values of the channel parameter.

      @ref tutorial_kinect_openni
    *)
    // CV_WRAP virtual Bool grab();

    (* * @brief Decodes and returns the grabbed video frame.

      @param [out] image the video frame is returned here. If no frames has been grabbed the image will be empty.
      @param flag it could be a frame index or a driver specific flag
      @return `false` if no frames has been grabbed

      The method decodes and returns the just grabbed frame. If no frames has been grabbed
      (camera has been disconnected, or there are no more frames in video file), the method returns false
      and the function returns an empty image (with %cv::Mat, test it with Mat::empty()).

      @sa read()

      @note In @ref videoio_c "C API", functions cvRetrieveFrame() and cv.RetrieveFrame() return image stored inside the video
      capturing structure. It is not allowed to modify or release the image! You can copy the frame using
      cvCloneImage and then do whatever you want with the copy.
    *)
    // CV_WRAP virtual Bool retrieve(OutputArray image, int flag = 0);

    (* * @brief Stream operator to read the next video frame.
      @sa read()
    *)
    // virtual VideoCapture & operator >> (CV_OUT Mat & image);

    (* * @overload
      @sa read()
    *)
    // virtual VideoCapture & operator >> (CV_OUT UMAT & image);

    (* * @brief Grabs, decodes and returns the next video frame.

      @param [out] image the video frame is returned here. If no frames has been grabbed the image will be empty.
      @return `false` if no frames has been grabbed

      The method/function combines VideoCapture::grab() and VideoCapture::retrieve() in one call. This is the
      most convenient method for reading video files or capturing data from decode and returns the just
      grabbed frame. If no frames has been grabbed (camera has been disconnected, or there are no more
      frames in video file), the method returns false and the function returns empty image (with %cv::Mat, test it with Mat::empty()).

      @note In @ref videoio_c "C API", functions cvRetrieveFrame() and cv.RetrieveFrame() return image stored inside the video
      capturing structure. It is not allowed to modify or release the image! You can copy the frame using
      cvCloneImage and then do whatever you want with the copy.
    *)
    function read(const image: TOutputArray): Bool; {$IFDEF USE_INLINE}inline; {$ENDIF}// CV_WRAP virtual Bool read(OutputArray image);

    (* * @brief Sets a property in the VideoCapture.

      @param propId Property identifier from cv::VideoCaptureProperties (eg. cv::CAP_PROP_POS_MSEC, cv::CAP_PROP_POS_FRAMES, ...)
      or one from @ref videoio_flags_others
      @param value Value of the property.
      @return `true` if the property is supported by backend used by the VideoCapture instance.
      @note Even if it returns `true` this doesn't ensure that the property
      value has been accepted by the capture device. See note in VideoCapture::get()
    *)
    // CV_WRAP virtual Bool set (int propId, double value);

    (* * @brief Returns the specified VideoCapture property

      @param propId Property identifier from cv::VideoCaptureProperties (eg. cv::CAP_PROP_POS_MSEC, cv::CAP_PROP_POS_FRAMES, ...)
      or one from @ref videoio_flags_others
      @return Value for the specified property. Value 0 is returned when querying a property that is
      not supported by the backend used by the VideoCapture instance.

      @note Reading / writing properties involves many layers. Some unexpected result might happens
      along this chain.
      @code{.txt}
      VideoCapture -> API Backend -> Operating System -> Device Driver -> Device Hardware
      @endcode
      The returned value might be different from what really used by the device or it could be encoded
      using device dependent rules (eg. steps or percentage). Effective behaviour depends from device
      driver and API Backend

    *)
    // CV_WRAP virtual double get(int propId)  const;

    (* * @brief Returns used backend API name

      @note Stream should be opened.
    *)
    // CV_WRAP String getBackendName()  const;

    (* * Switches exceptions mode
      *
      * methods raise exceptions if not successful instead of returning an error code
    *)
    // CV_WRAP void setExceptionMode(Bool enable) { throwOnFail = enable; }

    /// query if exception mode is active
    // CV_WRAP Bool getExceptionMode() { return throwOnFail; }

    (* * @brief Wait for ready frames from VideoCapture.

      @param streams input video streams
      @param readyIndex stream indexes with grabbed frames (ready to use .retrieve() to fetch actual frame)
      @param timeoutNs number of nanoseconds (0 - infinite)
      @return `true` if streamReady is not empty

      @throws Exception %Exception on stream errors (check .isOpened() to filter out malformed streams) or VideoCapture type is not supported

      The primary use of the function is in multi-camera environments.
      The method fills the ready state vector, grabs video frame, if camera is ready.

      After this call use VideoCapture::retrieve() to decode and fetch frame data.
    *)
    // static (* CV_WRAP *) Bool waitAny(const std: : vector<VideoCapture> & streams, CV_OUT std: : vector<int> & readyIndex, int64 timeoutNs = 0);

  private
{$HINTS OFF}
    Dummy: array [0 .. 47] of byte;
    // Ptr<CvCapture> cap;
    // Ptr<IVideoCapture> icap;
    // bool throwOnFail;

    // friend class internal::VideoCapturePrivateAccessor;
{$HINTS ON}
  end;

{$ENDREGION 'videoio.hpp'}
  //
{$REGION 'opencv_word helpers'}

Type
  TMatHelper = record helper for TMat
  public
    procedure copyTo(m: TOutputArray); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}         // void copyTo( OutputArray m ) const;
    procedure copyTo(m: TOutputArray; mask: TInputArray); overload; {$IFDEF USE_INLINE}inline; {$ENDIF}// void copyTo( OutputArray m, InputArray mask ) const;
    class function Mat(const m: TRect): TMat; static;
    class operator Implicit(const m: TRect): TMat; // Mat Mat::operator()( const Rect& roi ) const
  end;
{$ENDREGION 'opencv_word helpers'}
  //
{$REGION 'opencv_delphi helpers'}

  StdVectorRectHelper = record helper for StdVectorRect
  private
    function GetItems(const index: UInt64): TRect;
  public
    property Items[const index: UInt64]: TRect read GetItems; default;
  end;

{$ENDREGION 'opencv_delphi helpers'}
  //
{$REGION 'Import'}
{$I opencv.mat.import.inc}
{$I opencv.InputArray.import.inc}
{$I opencv.Scalar.import.inc}
{$I opencv.OutputArray.import.inc}
{$I opencv.InputOutputArray.import.inc}
{$I opencv.MatExpr.import.inc}
{$I opencv.MatSize.import.inc}
{$I opencv.operator.import.inc}
{$I opencv.CascadeClassifier.import.inc}
{$I opencv.VideoCapture.import.inc}
{$ENDREGION 'Import'}

implementation

function noArray(): TInputOutputArray;
begin
  Result := TInputOutputArray.noArray;
end;

procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT }; const borderValue: TScalar { = morphologyDefaultBorderValue() } );
begin
  _dilate(Src, dst, kernel, UInt64(anchor), iterations, int(borderType), borderValue);
end;

procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 };
  const borderType: BorderTypes { = BORDER_CONSTANT } );
begin
  dilate(Src, dst, kernel, anchor, iterations, borderType, morphologyDefaultBorderValue());
end;

procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) }; const iterations: int { = 1 } );
begin
  dilate(Src, dst, kernel, anchor, iterations, BORDER_CONSTANT);
end;

procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) } );
begin
  dilate(Src, dst, kernel, anchor, 1);
end;

procedure dilate(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray);
begin
  dilate(Src, dst, kernel, Point(-1, -1));
end;

function morphologyDefaultBorderValue(): TScalar;
begin
  Result := TScalar.all(DBL_MAX);
end;

procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint; const iterations: int; const borderType: BorderTypes;
  const borderValue: TScalar { = morphologyDefaultBorderValue() } );
begin
  _erode(Src, dst, kernel, UInt64(anchor), iterations, int(borderType), borderValue);
end;

procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint; const iterations: int; const borderType: BorderTypes { = BORDER_CONSTANT } );
begin
  erode(Src, dst, kernel, anchor, iterations, borderType, morphologyDefaultBorderValue());
end;

procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint; const iterations: int { = 1 } );
begin
  erode(Src, dst, kernel, anchor, iterations, BORDER_CONSTANT);
end;

procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray; const anchor: TPoint { = Point(-1,-1) } );
begin
  erode(Src, dst, kernel, anchor, 1);
end;

procedure erode(const Src: TInputArray; const dst: TOutputArray; const kernel: TInputArray);
begin
  erode(Src, dst, kernel, Point(-1, -1));
end;

function getStructuringElement(shape: MorphShapes; ksize: TSize): TMat;
begin
  Result := getStructuringElement(shape, ksize, Point(-1, -1));
end;

function getStructuringElement(shape: MorphShapes; ksize: TSize; anchor: TPoint): TMat;
begin
  Result := _getStructuringElement(int(shape), UInt64(ksize), UInt64(anchor));
end;

procedure adaptiveThreshold(Src: TInputArray; dst: TOutputArray; maxValue: double; adaptiveMethod: AdaptiveThresholdTypes; thresholdType: ThresholdTypes; blockSize: int; c: double);
begin
  _adaptiveThreshold(Src, dst, maxValue, int(adaptiveMethod), int(thresholdType), blockSize, c);
end;

procedure cvtColor(Src: TInputArray; dst: TOutputArray; code: ColorConversionCodes; dstCn: int = 0);
begin
  _cvtColor(Src, dst, int(code), dstCn);
end;

procedure GaussianBlur(Src: TInputArray; dst: TOutputArray; ksize: TSize; sigmaX: double; sigmaY: double; borderType: BorderTypes);
begin
  _GaussianBlur(Src, dst, UInt64(ksize), sigmaX, sigmaY, int(borderType));
end;

procedure blur(Src: TInputArray; dst: TOutputArray; ksize: TSize);
begin
  blur(Src, dst, ksize, Point(-1, -1), BORDER_DEFAULT);
end;

procedure blur(Src: TInputArray; dst: TOutputArray; ksize: TSize; anchor: TPoint; borderType: BorderTypes);
begin
  _blur(Src, dst, UInt64(ksize), UInt64(anchor), int(borderType));
end;

procedure putText(img: TInputOutputArray;

  const text: CppString; org: TPoint; fontFace: HersheyFonts; fontScale: double; color: TScalar; thickness: int = 1; lineType: LineTypes = LINE_8; bottomLeftOrigin: Bool = false);
begin
  _putText(img, text, UInt64(org), fontFace, fontScale, color, thickness, lineType, bottomLeftOrigin);
end;

procedure copyMakeBorder(const Src: TInputArray; Var dst: TOutputArray; top, bottom, left, right, borderType: int); overload;
Var
  Scalar: TScalar;
begin
  copyMakeBorder(Src, dst, top, bottom, left, right, borderType, Scalar);
end;

procedure bitwise_not(Src: TInputArray; dst: TOutputArray; mask: TInputArray { = noArray() } );
begin
  _bitwise_not(Src, dst, mask);
end;

procedure bitwise_not(Src: TInputArray; dst: TOutputArray);
begin
  _bitwise_not(Src, dst, noArray());
end;

{ TMat }

class operator TMat.Implicit(const m: TMatExpr): TMat;
begin
  Mat_Operator_Assign(@Result, @m);
end;

class operator TMat.Initialize(out Dest: TMat);
begin
  Constructor_Mat(@Dest);
end;

class operator TMat.Finalize(var Dest: TMat);
begin
  Destructor_Mat(@Dest);
end;

function TMat.clone: TMat;
begin
  clone_Mat(@Self, @Result);
end;

function TMat.diag(d: int): TMat;
begin
  diag_Mat(@Self, @Result, d);
end;

function TMat.isContinuous: Bool;
begin
  Result := isContinuous_Mat(@Self);
end;

function TMat.isSubmatrix: Bool;
begin
  Result := isSubmatrix_Mat(@Self);
end;

class operator TMat.LogicalNot(const m: TMat): TMatExpr;
begin
  MatExpr_LogicalNot_Mat(@Result, @m);
end;

class function TMat.ones(rows, cols, &type: int): TMatExpr;
begin
  ones_Mat(@Result, rows, cols, &type);
end;

class function TMat.ones(ndims: int; const sz: pInt; &type: int): TMat;
begin
  ones_Mat(@Result, ndims, sz, &type);
end;

function TMat.step1(i: int): size_t;
begin
  Result := step1_Mat(@Self, i);
end;

class operator TMat.assign(var Dest: TMat; const [ref] Src: TMat);
begin
  Finalize(Dest);
  clone_Mat(@Src, @Dest);
end;

function TMat.channels: int;
begin
  Result := channels_Mat(@Self);
end;

function TMat.checkVector(elemChannels, depth: int; requireContinuous: Bool): int;
begin
  Result := checkVector_Mat(@Self, elemChannels, depth, requireContinuous);
end;

procedure TMat.create(rows, cols, &type: int);
begin
  Constructor_Mat(@Self, rows, cols, &type);
end;

function TMat.depth: int;
begin
  Result := depth_Mat(@Self);
end;

function TMat.elemSize: size_t;
begin
  Result := elemSize_Mat(@Self);
end;

function TMat.elemSize1: size_t;
begin
  Result := elemSize1_Mat(@Self);
end;

function TMat.empty: Bool;
begin
  Result := empty_Mat(@Self);
end;

function TMat.total(startDim, endDim: int): size_t;
begin
  Result := total_Mat(@Self, startDim, endDim);
end;

function TMat.total: size_t;
begin
  Result := total_Mat(@Self);
end;

function TMat.&type: int;
begin
  Result := type_Mat(@Self);
end;

class function TMat.zeros(

  const size: TSize; &type: int): TMatExpr;
begin
  zeros_Mat(@Result, UInt64(size), &type);
end;

{ TInputArray }

class operator TInputArray.Implicit(const m: TMat): TInputArray;
begin
  Result := TInputArray.InputArray(m);
end;

function TInputArray.getObj: Pointer;
begin
  Result := getObj_InputArray(@Self);
end;

class operator TInputArray.Implicit(const IA: TInputArray): TMat;
begin
  Assert(IA.isMat);
  Result := pMat(IA.getObj)^.clone;
end;

class operator TInputArray.Implicit(const m: TMatExpr): TInputArray;
begin
  Constructor_InputArray(@Result, pMatExpr(@m));
end;

class operator TInputArray.Initialize(out Dest: TInputArray);
begin
  Constructor_InputArray(@Dest);
end;

class function TInputArray.InputArray(const m: TMat): TInputArray;
begin
  Constructor_InputArray(@Result, pMat(@m));
end;

class operator TInputArray.Finalize(var Dest: TInputArray);
begin
  Destructor_InputArray(@Dest);
end;

function TInputArray.isMat: Bool;
begin
  Result := isMat_InputArray(@Self);
end;

{ TOutputArray }

class operator TOutputArray.Initialize(out Dest: TOutputArray);
begin
  Constructor_OutputArray(@Dest);
end;

class function TOutputArray.OutputArray(const m: TMat): TOutputArray;
begin
  Constructor_OutputArray(@Result, @m);
end;

class operator TOutputArray.Finalize(var Dest: TOutputArray);
begin
  Destructor_OutputArray(@Dest);
end;

class operator TOutputArray.Implicit(const m: TMat): TOutputArray;
begin
  Result := TOutputArray.OutputArray(m);
end;

class operator TOutputArray.Implicit(const OA: TOutputArray): TMat;
begin
  Assert(OA.InputArray.isMat);
  Result := pMat(OA.InputArray.getObj)^;
end;

{ TScalar }

class function TScalar.create(const v0, v1, v2, v3: double): TScalar;
begin
  constructor_Scalar(@Result, v0, v1, v2, v3);
end;

class function TScalar.all(const v0: double): TScalar;
begin
  Result := TScalar.create(v0, v0, v0, v0);
end;

class function TScalar.create(const v0: double): TScalar;
begin
  constructor_Scalar(@Result, v0);
end;

class operator TScalar.Implicit(const v0: double): TScalar;
begin
  Result := TScalar.create(v0);
end;

class operator TScalar.Initialize(out Dest: TScalar);
begin
  constructor_Scalar(@Dest);
end;

function Scalar(const v0, v1, v2, v3: double): TScalar;
begin
  Result := TScalar.create(v0, v1, v2, v3);
end;

{ TSize_<T> }

class function TSize_<T>.size(const _width, _height: T): TSize_<T>;
begin
  Result.width := _width;
  Result.height := _height;
end;

function size(const _width, _height: int): TSize;
begin
  Result := TSize.size(_width, _height);
end;

{ TMatExpr }

class operator TMatExpr.Finalize(var Dest: TMatExpr);
begin
  Destructor_MatExpr(@Dest);
end;

class operator TMatExpr.Initialize(out Dest: TMatExpr);
begin
  constructor_MatExpr(@Dest);
end;

function TMatExpr.size: TSize;
begin
  Result := MatExpr_size(@Self, @Result)^;
end;

{ TMatSize }

class operator TMatSize.Implicit(const m: TMatSize): TSize;
begin
  operator_MatSize_MatSizeToSize(@m, @Result);
end;

{ TInputOutputArray }

class operator TInputOutputArray.Finalize(var Dest: TInputOutputArray);
begin
  Destructor_InputOutputArray(@Dest);
end;

class operator TInputOutputArray.Implicit(const IOA: TInputOutputArray): TMat;
begin
  Assert(IOA.OutputArray.InputArray.isMat);
  Result := pMat(IOA.OutputArray.InputArray.getObj)^;
end;

class operator TInputOutputArray.Implicit(const m: TMat): TInputOutputArray;
begin
  Result.InputOutputArray(m);
end;

class operator TInputOutputArray.Initialize(out Dest: TInputOutputArray);
begin
  Constructor_InputOutputArray(@Dest);
end;

procedure TInputOutputArray.InputOutputArray(const m: TMat);
begin
  Constructor_InputOutputArray(@Self, @m);
end;

class function TInputOutputArray.noArray: TInputOutputArray;
begin
  noArray_InputOutputArray(@Result);
end;

class operator TInputOutputArray.Implicit(const IOA: TInputOutputArray): TInputArray;
begin
  Result := IOA.OutputArray.InputArray;
end;

{ TPoint_<T> }

class function TPoint_<T>.Point(_x, _y: T): TPoint_<T>;
begin
  Result.x := _x;
  Result.y := _y;
end;

function Point(const _x, _y: int): TPoint;
begin
  Result := TPoint.Point(_x, _y);
end;

function CV_MAT_DEPTH(flags: int): int;
begin
  Result := flags and CV_MAT_DEPTH_MASK;
end;

function CV_MAKETYPE(depth, cn: int): int;
begin
  Result := (CV_MAT_DEPTH(depth) + (((cn) - 1) shl CV_CN_SHIFT));
end;

function CV_MAKE_TYPE(depth, cn: int): int;
begin
  Result := CV_MAKETYPE(depth, cn);
end;

function CV_8UC(n: int): int;
begin
  Result := CV_MAKETYPE(CV_8U, n);
end;

{ TMatHelper }

procedure TMatHelper.copyTo(m: TOutputArray);
begin
  copyTo_Mat(@Self, @m);
end;

procedure TMatHelper.copyTo(m: TOutputArray; mask: TInputArray);
begin
  copyTo_Mat(@Self, @m, @mask);
end;

class operator TMatHelper.Implicit(const m: TRect): TMat;
begin
  Constructor_Mat(@Result, @Result, pRect(@m));
end;

class function TMatHelper.Mat(const m: TRect): TMat;
begin
  Result := m;
end;

{ TCascadeClassifier }

procedure TCascadeClassifier.detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double; minNeighbors, flags: int);
begin
  detectMultiScale(image, objects, scaleFactor, minNeighbors, flags, size(0, 0));
end;

procedure TCascadeClassifier.detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double; minNeighbors, flags: int; const minSize: TSize);
begin
  detectMultiScale(image, objects, scaleFactor, minNeighbors, flags, minSize, size(0, 0));
end;

procedure TCascadeClassifier.detectMultiScale(const image: TInputArray; const objects: StdVectorRect; scaleFactor: double; minNeighbors, flags: int; const minSize, maxSize: TSize);
begin
  detectMultiScale_CascadeClassifier(@Self, @image, @objects, scaleFactor, minNeighbors, flags, UInt64(minSize), UInt64(maxSize));
end;

class operator TCascadeClassifier.Finalize(var Dest: TCascadeClassifier);
begin
  Destructor_CascadeClassifier(@Dest);
end;

class operator TCascadeClassifier.Initialize(out Dest: TCascadeClassifier);
begin
  Constructor_CascadeClassifier(@Dest);
end;

function TCascadeClassifier.load(const filename: CvStdString): Bool;
begin
  Result := load_CascadeClassifier(@Self, @filename);
end;

function TCascadeClassifier.load(const filename: String): Bool;
begin
  Result := load_CascadeClassifier(@Self, @CvStdString(filename));
end;

{ StdVectorRectHelper }

function StdVectorRectHelper.GetItems(const index: UInt64): TRect;
begin
  Result := pRect(operator_get_StdVectorRect(@Self, index))^;
end;

{ TVideoCapture }

class operator TVideoCapture.Finalize(var Dest: TVideoCapture);
begin
  destructor_VideoCapture(@Dest);
end;

class operator TVideoCapture.Initialize(out Dest: TVideoCapture);
begin
  constructor_VideoCapture(@Dest);
end;

function TVideoCapture.isOpened: Bool;
begin
  Result := isOpened_VideoCapture(@Self);
end;

function TVideoCapture.open(const index: int; const apiPreference: VideoCaptureAPIs): Bool;
begin
  Result := open_VideoCapture(@Self, index, int(apiPreference));
end;

function TVideoCapture.read(const image: TOutputArray): Bool;
begin
  Result := read_VideoCapture(@Self, @image);
end;

initialization

{$REGION 'Interface.h'}
  CV_8UC1 := CV_MAKETYPE(CV_8U, 1);
CV_8UC2 := CV_MAKETYPE(CV_8U, 2);
CV_8UC3 := CV_MAKETYPE(CV_8U, 3);
CV_8UC4 := CV_MAKETYPE(CV_8U, 4);
{$ENDREGION}

end.