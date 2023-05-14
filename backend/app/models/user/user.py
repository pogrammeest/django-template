import uuid
from django.contrib.auth.base_user import AbstractBaseUser, BaseUserManager
from django.contrib.auth.models import PermissionsMixin, Permission, Group

from django.db.models import (
    CharField,
    EmailField,
    BooleanField,
    TextField,
    UUIDField,
)
from django.db import models


class UserManager(BaseUserManager):
    def create_user(self, password=None, email=None, **kwargs):
        email = email and self.normalize_email(email)
        user = self.model(email=email, **kwargs)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, username=None, email=None, password=None, **kwargs):
        kwargs.setdefault("is_staff", True)
        kwargs.setdefault("is_superuser", True)
        if kwargs.get("is_staff") is not True:
            raise ValueError("Superuser must have is_staff=True.")
        if kwargs.get("is_superuser") is not True:
            raise ValueError("Superuser must have is_superuser=True.")
        return self.create_user(password, email, **kwargs)


class User(AbstractBaseUser, PermissionsMixin):
    groups = models.ManyToManyField(Group, related_name='myapp_users')
    user_permissions = models.ManyToManyField(Permission, related_name='app_users')
    uuid = UUIDField(unique=True, default=uuid.uuid4, editable=False, null=False, blank=False)
    email = EmailField("Email", unique=True)
    is_staff = BooleanField("Администрация", default=False)
    confirmed_email = BooleanField("Подтвержденная почта", default=False)

    USERNAME_FIELD = "email"

    objects = UserManager()

    def __str__(self) -> str:
        return f"{self.last_name} {self.first_name}"

    class Sex(models.TextChoices):
        MALE = "ML", "Мужчина"
        FEMALE = "FM", "Женщина"

    first_name = CharField("Имя", max_length=31)
    last_name = CharField("Фамилия", max_length=31)
    patronymic = CharField("Отчество", max_length=31, blank=True, null=True)
    sex = CharField(max_length=2, choices=Sex.choices, null=True, blank=True)
    about = TextField("О себе", max_length=2000, blank=True, null=True)

    class Meta:
        verbose_name = "Пользователь"
        verbose_name_plural = "Реестр пользователей"
