
class SubmitForm{
    String formId;
    String username;
    String formName;
    String type;
    String date;
    List<DataItem> data;

    SubmitForm(this.formId, this.username, this.formName, this.type, this.date){
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
        'type' : type,
        'submit_date' : date,
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