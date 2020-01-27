class FormList {
    List<RawForm> forms;
    int status;
    String description;

    FormList({this.forms, this.status, this.description});

    FormList.fromJson(Map<String, dynamic> json) {
        if (json['forms'] != null) {
            forms = new List<RawForm>();
            json['forms'].forEach((v) {
                forms.add(new RawForm.fromJson(v));
            });
        }
        status = json['status'];
        description = json['description'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        if (this.forms != null) {
            data['forms'] = this.forms.map((v) => v.toJson()).toList();
        }
        data['status'] = this.status;
        data['description'] = this.description;
        return data;
    }
}

class RawForm {
    String sId;
    String title;
    String id;
    List<Field> fields;

    RawForm({this.sId, this.title, this.id, this.fields});

    RawForm.fromJson(Map<String, dynamic> json) {
        sId = json['_id'];
        title = json['title'];
        id = json['id'];
        if (json['fields'] != null) {
            fields = new List<Field>();
            json['fields'].forEach((v) {
                fields.add(new Field.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['_id'] = this.sId;
        data['title'] = this.title;
        data['id'] = this.id;
        if (this.fields != null) {
            data['fields'] = this.fields.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Field {
    String name;
    String title;
    String type;
    bool required;
    List<Option> options;

    Field({this.name, this.title, this.type, this.required, this.options});

    Field.fromJson(Map<String, dynamic> json) {
        name = json['name'];
        title = json['title'];
        type = json['type'];
        required = json['required'];
        if (json['options'] != null) {
            options = new List<Option>();
            json['options'].forEach((v) {
                options.add(new Option.fromJson(v));
            });
        }
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['name'] = this.name;
        data['title'] = this.title;
        data['type'] = this.type;
        data['required'] = this.required;
        if (this.options != null) {
            data['options'] = this.options.map((v) => v.toJson()).toList();
        }
        return data;
    }
}

class Option {
    String label;
    String value;

    Option({this.label, this.value});

    Option.fromJson(Map<String, dynamic> json) {
        label = json['label'];
        value = json['value'];
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['label'] = this.label;
        data['value'] = this.value;
        return data;
    }
}