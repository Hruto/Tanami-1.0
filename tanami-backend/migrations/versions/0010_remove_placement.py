"""Hapus konsep indoor/outdoor dari lahan dan tanaman.

Revision ID: 0010
Revises: 0009

Produk tidak lagi memakai ``placement`` (indoor/outdoor). Kolom lama di
``farms`` dan ``plants`` beserta CHECK constraint dan index tanaman dibuang.
Downgrade menambahkan kembali kolom dengan default ``outdoor`` supaya riwayat
migrasi tetap aman.
"""

from __future__ import annotations

from collections.abc import Sequence

import sqlalchemy as sa
from alembic import op

revision: str = "0010"
down_revision: str | None = "0009"
branch_labels: str | Sequence[str] | None = None
depends_on: str | Sequence[str] | None = None


def upgrade() -> None:
    op.drop_index("ix_plants_placement", table_name="plants")
    op.drop_constraint(op.f("ck_plants_ck_plants_placement"), "plants", type_="check")
    op.drop_column("plants", "placement")

    op.drop_constraint(op.f("ck_farms_placement"), "farms", type_="check")
    op.drop_column("farms", "placement")


def downgrade() -> None:
    op.add_column(
        "farms",
        sa.Column("placement", sa.String(length=16), server_default="outdoor", nullable=False),
    )
    op.create_check_constraint(
        op.f("ck_farms_placement"), "farms", "placement IN ('indoor', 'outdoor')"
    )

    op.add_column(
        "plants",
        sa.Column("placement", sa.String(length=16), server_default="outdoor", nullable=False),
    )
    op.create_check_constraint(
        op.f("ck_plants_ck_plants_placement"), "plants", "placement IN ('indoor', 'outdoor')"
    )
    op.create_index("ix_plants_placement", "plants", ["placement"])