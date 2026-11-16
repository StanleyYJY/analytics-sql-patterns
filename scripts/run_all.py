"""Run every query in sql/ against the public dataset and write the output to results/."""
from pathlib import Path
import time

import duckdb

ROOT = Path(__file__).resolve().parents[1]


def main() -> None:
    con = duckdb.connect()
    import os
    os.chdir(ROOT)
    con.execute((ROOT / "sql" / "00_setup.sql").read_text())
    out = ROOT / "results"
    out.mkdir(exist_ok=True)
    for f in sorted((ROOT / "sql").glob("[0-9][0-9]_*.sql")):
        if f.name.startswith("00_"):
            continue
        sql = f.read_text()
        question = next(l[5:].strip() for l in sql.splitlines() if l.startswith("-- Q:"))
        t = time.perf_counter()
        df = con.execute(sql).df()
        ms = (time.perf_counter() - t) * 1000
        for c in df.columns:
            if df[c].dtype.kind == "f" and df[c].dropna().apply(float.is_integer).all():
                df[c] = df[c].astype("Int64")
        md = f"# {f.stem}\n\n**Question.** {question}\n\n```sql\n{sql.strip()}\n```\n\n**Result** ({len(df)} rows shown, {ms:.0f} ms):\n\n{df.head(25).to_markdown(index=False, intfmt=',')}\n"
        (out / f"{f.stem}.md").write_text(md)
        print(f"{f.stem:42s} {len(df):>4} rows  {ms:6.0f} ms")


if __name__ == "__main__":
    main()
