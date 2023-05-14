from rest_framework import serializers

from app.models.user import User


class ProfileSerializer(serializers.ModelSerializer):
    email = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = "__all__"
