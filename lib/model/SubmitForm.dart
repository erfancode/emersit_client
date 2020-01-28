
class SubmitForm{
    String formId;
    String username;
    String formName;
    List<DataItem> data;

    SubmitForm(this.formId, this.username, this.formName){
        data = List();
    }

    void addKeyValue(String name, String value){
        data.add(DataItem(name, value));
    }

    Map<String, dynamic> toJson() =>
    {
        'form_id': formId,
        'username': username,
        'form_name':formName,
        'data' : DataItem.encodeToJson(data),
    };
}

class DataItem{

    String name;
    String value;

    DataItem(this.name, this.value);

    Map<String, dynamic> toJson() =>
    {
        'name': name,
        'value': value,
    };

    static List encodeToJson(List<DataItem> list){
        List jsonList = List();
        list.map((item)=>
                jsonList.add(item.toJson())
        ).toList();
        return jsonList;
    }
}