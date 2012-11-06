class RawCodeFactory : public IMEngineFactoryBase
{
  friend class RawCodeInstance;
public:
  RawCodeFactory ();
};
class IMEngineFactoryBase : public ReferencdObject
{
  class IMEngineFactoryBaseImpl;
  IMEngineFactoryBaseImpl *m_impl;
public:
  IMEngineFactoryBase ();
protected:
  void set_locales (const String &locales);
};
class IMEngineFactoryBase::IMEngineFactoryBaseImpl
{
public:
  std::vector<String> m_encoding_list;
  std::vector<String> m_locale_list;
  String m_language;
};
class RawCodeInstance : public IMEngineInstanceBase {
  IConvert m_client_iconv;
public:
  RawCodeInstance (RawCodeFactory *factory, const String &encoding, int id = -1);
  virtual void reset ();
};
class IMEngineInstanceBase : public ReferencedObject {
  class IMEngineInstanceBaseImpl;
  IMEngineInstanceBaseImpl *m_impl;
public:
  Connection signal_connect_show_preedit_string (IMEngineSlotVoid *slot);
  virtual void reset ();
};
class IMEngineInstaceBase::IMEngineInstanceBaseImpl {
public:
  IMEngineSignalVoid m_signal_show_preedit_string;
  IMEngineInstanceBaseImpl ();
};
typedef Signal1<void, IMEngineInstanceBase *>
	IMEngineSignalVoid;
template <typename R, typename P1, typename Marshal = class DefaultMarshal<R>>
class Signal1 : public Signal {
};
class Signal {
public:
  SlotNode *connect (Slot *slot);
};
class SlotNode : public Node {
};
class Slot : public ReferencedObject {
};
template <typename R>
class DefaultMarshal {};
template <typename T>
class Pointer
{
  T *t;
  void set (T *object);
public:
  void reset (T *object = 0);
};
class ReferencedObject {
protected:
  ReferencedObject ();
public:
  void unref ();
};
class IConvert {
  class IConvertImpl;
  IConvertImpl *m_impl;
};
struct IConvert::IConvertImpl {
};
// ucs4_t UCS-4LE
~/source/scim/scim-1.4.14/modules/IMEngine/scim_rawcode_imengine.cpp
~/source/scim/scim-1.4.14/src/scim_imengine.cpp
