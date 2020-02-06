

class SubmittedFormList {
    List<Forms> forms;

    SubmittedFormList({this.forms});

    SubmittedFormList.fromJson(Map<String, dynamic> json) {
        if (json['forms'] != null) {
            forms = new List<Forms>();
            json['forms'].forEach((v) {
                forms.add(new Forms.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.forms != null) {
            data['forms'] = this.forms.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Forms {
    String sId;
    String formId;
    String username;
    String formName;
    String type;
    String date;
    List<Data> data;

    Forms({this.sId, this.formId, this.username, this.formName, this.data, this.type, this.date});

    Forms.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        formId = json['form_id'];
        username = json['username'];
        formName=json['form_name'];
        type = json['type'];
        date = json['submit_date'];
        if (json['data'] != null) {
            data = new List<Data>();
            json['data'].forEach((v) {
                data.add(new Data.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['form_id'] = this.formId;
        data['username'] = this.username;
        data['form_name'] = this.formName;
        data['type'] = this.type;
        data['submit_date'] = this.date;
        if (this.data != null) {
            data['data'] = this.data.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Data {
    String name;
    String value;

    Data({this.name, this.value});

    Data.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        value = json['value'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['value'] = this.value;
        return data;
    }
}