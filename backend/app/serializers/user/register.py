from django.contrib.auth import get_user_model
from rest_framework.serializers import (
    ModelSerializer,
    CharField,
    ValidationError,
)
from django.contrib.auth.password_validation import validate_password
from django.core import exceptions

User = get_user_model()


class RegisterSerializer(ModelSerializer):
    confirm_password = CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "id",
            "password",
            "confirm_password",
            "email",
        ]
        extra_kwargs = {"password": {"write_only": True}}

    def validate(self, data):
        if not data.get("password") == data.get("confirm_password"):
            raise ValidationError({'password': ["Пароли не совпадают"]})
        try:
            validate_password(data.get("password"))
        except exceptions.ValidationError as e:
            raise ValidationError({'password': list(e.messages)})
        return super(RegisterSerializer, self).validate(data)
