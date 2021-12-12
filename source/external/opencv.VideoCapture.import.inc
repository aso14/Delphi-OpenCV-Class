// ??0VideoCapture@cv@@QEAA@AEBV01@@Z	public: __cdecl cv::VideoCapture::VideoCapture(class cv::VideoCapture const & __ptr64) __ptr64
// ??0VideoCapture@cv@@QEAA@AEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z	public: __cdecl cv::VideoCapture::VideoCapture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const & __ptr64,int) __ptr64
// ??0VideoCapture@cv@@QEAA@AEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@HAEBV?$vector@HV?$allocator@H@std@@@3@@Z	public: __cdecl cv::VideoCapture::VideoCapture(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const & __ptr64,int,class std::vector<int,class std::allocator<int> > const & __ptr64) __ptr64
// ??0VideoCapture@cv@@QEAA@HH@Z	public: __cdecl cv::VideoCapture::VideoCapture(int,int) __ptr64
// ??0VideoCapture@cv@@QEAA@HHAEBV?$vector@HV?$allocator@H@std@@@std@@@Z	public: __cdecl cv::VideoCapture::VideoCapture(int,int,class std::vector<int,class std::allocator<int> > const & __ptr64) __ptr64
// 1317
// ??0VideoCapture@cv@@QEAA@XZ
// public: __cdecl cv::VideoCapture::VideoCapture(void) __ptr64
procedure constructor_VideoCapture(const Obj: TVideoCapture); external opencv_world_dll
// index 1317
  name '??0VideoCapture@cv@@QEAA@XZ'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
{
  1804
  ??1VideoCapture@cv@@UEAA@XZ
  public: virtual __cdecl cv::VideoCapture::~VideoCapture(void) __ptr64
}
procedure destructor_VideoCapture(const Obj: TVideoCapture); external opencv_world_dll name '??1VideoCapture@cv@@UEAA@XZ'{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};

// ??4VideoCapture@cv@@QEAAAEAV01@AEBV01@@Z	public: class cv::VideoCapture & __ptr64 __cdecl cv::VideoCapture::operator=(class cv::VideoCapture const & __ptr64) __ptr64
// ??5VideoCapture@cv@@UEAAAEAV01@AEAVMat@1@@Z	public: virtual class cv::VideoCapture & __ptr64 __cdecl cv::VideoCapture::operator>>(class cv::Mat & __ptr64) __ptr64
// ??5VideoCapture@cv@@UEAAAEAV01@AEAVUMat@1@@Z	public: virtual class cv::VideoCapture & __ptr64 __cdecl cv::VideoCapture::operator>>(class cv::UMat & __ptr64) __ptr64
// ??_7VideoCapture@cv@@6B@	const cv::VideoCapture::`vftable'
{
  ?get@VideoCapture@cv@@UEBANH@Z
  public: virtual double __cdecl cv::VideoCapture::get(int)const __ptr64
}
function get_VideoCapture(const Obj: TVideoCapture; propId: Int): double; external opencv_world_dll name '?get@VideoCapture@cv@@UEBANH@Z'{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // ?getBackendName@VideoCapture@cv@@QEBA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@XZ	public: class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl cv::VideoCapture::getBackendName(void)const __ptr64
  // ?getBackendName@videoio_registry@cv@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@W4VideoCaptureAPIs@2@@Z	class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl cv::videoio_registry::getBackendName(enum cv::VideoCaptureAPIs)
  // ?getBackends@videoio_registry@cv@@YA?AV?$vector@W4VideoCaptureAPIs@cv@@V?$allocator@W4VideoCaptureAPIs@cv@@@std@@@std@@XZ	class std::vector<enum cv::VideoCaptureAPIs,class std::allocator<enum cv::VideoCaptureAPIs> > __cdecl cv::videoio_registry::getBackends(void)
  // ?getCameraBackendPluginVersion@videoio_registry@cv@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@W4VideoCaptureAPIs@2@AEAH1@Z	class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl cv::videoio_registry::getCameraBackendPluginVersion(enum cv::VideoCaptureAPIs,int & __ptr64,int & __ptr64)
  // ?getCameraBackends@videoio_registry@cv@@YA?AV?$vector@W4VideoCaptureAPIs@cv@@V?$allocator@W4VideoCaptureAPIs@cv@@@std@@@std@@XZ	class std::vector<enum cv::VideoCaptureAPIs,class std::allocator<enum cv::VideoCaptureAPIs> > __cdecl cv::videoio_registry::getCameraBackends(void)
  // ?getExceptionMode@VideoCapture@cv@@QEAA_NXZ	public: bool __cdecl cv::VideoCapture::getExceptionMode(void) __ptr64
  // ?getStreamBackendPluginVersion@videoio_registry@cv@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@W4VideoCaptureAPIs@2@AEAH1@Z	class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl cv::videoio_registry::getStreamBackendPluginVersion(enum cv::VideoCaptureAPIs,int & __ptr64,int & __ptr64)
  // ?getStreamBackends@videoio_registry@cv@@YA?AV?$vector@W4VideoCaptureAPIs@cv@@V?$allocator@W4VideoCaptureAPIs@cv@@@std@@@std@@XZ	class std::vector<enum cv::VideoCaptureAPIs,class std::allocator<enum cv::VideoCaptureAPIs> > __cdecl cv::videoio_registry::getStreamBackends(void)
  // ?getWriterBackendPluginVersion@videoio_registry@cv@@YA?AV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@W4VideoCaptureAPIs@2@AEAH1@Z	class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > __cdecl cv::videoio_registry::getWriterBackendPluginVersion(enum cv::VideoCaptureAPIs,int & __ptr64,int & __ptr64)
  // ?getWriterBackends@videoio_registry@cv@@YA?AV?$vector@W4VideoCaptureAPIs@cv@@V?$allocator@W4VideoCaptureAPIs@cv@@@std@@@std@@XZ	class std::vector<enum cv::VideoCaptureAPIs,class std::allocator<enum cv::VideoCaptureAPIs> > __cdecl cv::videoio_registry::getWriterBackends(void)
  // ?grab@VideoCapture@cv@@UEAA_NXZ	public: virtual bool __cdecl cv::VideoCapture::grab(void) __ptr64
  // ?hasBackend@videoio_registry@cv@@YA_NW4VideoCaptureAPIs@2@@Z	bool __cdecl cv::videoio_registry::hasBackend(enum cv::VideoCaptureAPIs)
  // ?isBackendBuiltIn@videoio_registry@cv@@YA_NW4VideoCaptureAPIs@2@@Z	bool __cdecl cv::videoio_registry::isBackendBuiltIn(enum cv::VideoCaptureAPIs)
  // 5396
  // ?isOpened@VideoCapture@cv@@UEBA_NXZ
  // public: virtual bool __cdecl cv::VideoCapture::isOpened(void)const __ptr64
  function isOpened_VideoCapture(const Obj: TVideoCapture): Bool; external opencv_world_dll
  // index 5396
  name '?isOpened@VideoCapture@cv@@UEBA_NXZ'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // 5786
  // ?open@VideoCapture@cv@@UEAA_NAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z
  // public: virtual bool __cdecl cv::VideoCapture::open(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const & __ptr64,int) __ptr64
  function open_VideoCapture(const Obj: TVideoCapture; const filename: CppString; apiPreference: Int): Bool; overload; external opencv_world_dll
  // index 5786
  name '?open@VideoCapture@cv@@UEAA_NAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@H@Z'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // 5787
  // ?open@VideoCapture@cv@@UEAA_NAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@HAEBV?$vector@HV?$allocator@H@std@@@4@@Z
  // public: virtual bool __cdecl cv::VideoCapture::open(class std::basic_string<char,struct std::char_traits<char>,class std::allocator<char> > const & __ptr64,int,class std::vector<int,class std::allocator<int> > const & __ptr64) __ptr64
  function open_VideoCapture(const Obj: TVideoCapture; const  filename: CppString; apiPreference: Int;
  const params: Vector<Int>): Bool; overload; external opencv_world_dll
    name '?open@VideoCapture@cv@@UEAA_NAEBV?$basic_string@DU?$char_traits@D@std@@V?$allocator@D@2@@std@@HAEBV?$vector@HV?$allocator@H@std@@@4@@Z'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // 5788
  // ?open@VideoCapture@cv@@UEAA_NHH@Z
  // public: virtual bool __cdecl cv::VideoCapture::open(int,int) __ptr64
  function open_VideoCapture(const Obj: TVideoCapture; a: Int; b: Int): Bool; overload; external opencv_world_dll
  // index 5788
  name '?open@VideoCapture@cv@@UEAA_NHH@Z'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // ?open@VideoCapture@cv@@UEAA_NHHAEBV?$vector@HV?$allocator@H@std@@@std@@@Z	public: virtual bool __cdecl cv::VideoCapture::open(int,int,class std::vector<int,class std::allocator<int> > const & __ptr64) __ptr64
  {
    6005
    ?read@VideoCapture@cv@@UEAA_NAEBV_OutputArray@debug_build_guard@2@@Z
    ?read@VideoCapture@cv@@UEAA_NAEBV_OutputArray@2@@Z
    public: virtual bool __cdecl cv::VideoCapture::read(class cv::_OutputArray const & __ptr64) __ptr64
  }
  function read_VideoCapture(const Obj: TVideoCapture;const o: TOutputArray): Bool; external opencv_world_dll
{$IFDEF DEBUG}
  name '?read@VideoCapture@cv@@UEAA_NAEBV_OutputArray@debug_build_guard@2@@Z'
{$ELSE}
  name '?read@VideoCapture@cv@@UEAA_NAEBV_OutputArray@2@@Z'
{$ENDIF}
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  {
    6097
    ?release@VideoCapture@cv@@UEAAXXZ
    public: virtual void __cdecl cv::VideoCapture::release(void) __ptr64
  }
  procedure release_VideoCapture(const Obj: TVideoCapture); external opencv_world_dll name '?release@VideoCapture@cv@@UEAAXXZ'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // ?retrieve@VideoCapture@cv@@UEAA_NAEBV_OutputArray@2@H@Z	public: virtual bool __cdecl cv::VideoCapture::retrieve(class cv::_OutputArray const & __ptr64,int) __ptr64
  {
    6260
    ?set@VideoCapture@cv@@UEAA_NHN@Z
    public: virtual bool __cdecl cv::VideoCapture::set(int,double) __ptr64
  }
  function set_VideoCapture(const Obj: TVideoCapture; propId: Int; value: double): Bool; external opencv_world_dll name '?set@VideoCapture@cv@@UEAA_NHN@Z'
{$IFDEF DELAYED_LOAD_DLL} delayed{$ENDIF};
  // ?setExceptionMode@VideoCapture@cv@@QEAAX_N@Z	public: void __cdecl cv::VideoCapture::setExceptionMode(bool) __ptr64
  // ?waitAny@VideoCapture@cv@@SA_NAEBV?$vector@VVideoCapture@cv@@V?$allocator@VVideoCapture@cv@@@std@@@std@@AEAV?$vector@HV?$allocator@H@std@@@4@_J@Z	public: static bool __cdecl cv::VideoCapture::waitAny(class std::vector<class cv::VideoCapture,class std::allocator<class cv::VideoCapture> > const & __ptr64,class std::vector<int,class std::allocator<int> > & __ptr64,__int64)