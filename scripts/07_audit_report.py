import csv, datetime, subprocess, json, os

PROFILE = os.environ.get("PROFILE", "iam-labs")
today = datetime.date.today().isoformat()
out_dir = "docs/evidence"
os.makedirs(out_dir, exist_ok=True)
out = f"{out_dir}/weekly-audit-{today}.csv"

def aws(cmd):
    full = ["aws"] + cmd + ["--profile", PROFILE, "--output", "json"]
    return json.loads(subprocess.check_output(full).decode())

rows = []

# Users, their groups & attached policies
users = aws(["iam", "list-users"]).get("Users", [])
for u in users:
    uname = u["UserName"]
    groups = aws(["iam", "list-groups-for-user", "--user-name", uname]).get("Groups", [])
    pols = aws(["iam", "list-attached-user-policies", "--user-name", uname]).get("AttachedPolicies", [])
    rows.append(["USER", uname, ";".join([g["GroupName"] for g in groups]), ";".join([p["PolicyName"] for p in pols])])

# Groups, their attached policies
groups = aws(["iam", "list-groups"]).get("Groups", [])
for g in groups:
    gname = g["GroupName"]
    pols = aws(["iam", "list-attached-group-policies", "--group-name", gname]).get("AttachedPolicies", [])
    rows.append(["GROUP", gname, "", ";".join([p["PolicyName"] for p in pols])])

# Roles, their attached policies
roles = aws(["iam", "list-roles"]).get("Roles", [])
for r in roles:
    rname = r["RoleName"]
    pols = aws(["iam", "list-attached-role-policies", "--role-name", rname]).get("AttachedPolicies", [])
    rows.append(["ROLE", rname, "", ";".join([p["PolicyName"] for p in pols])])

with open(out, "w", newline="") as f:
    w = csv.writer(f)
    w.writerow(["Type", "Name", "Groups", "AttachedPolicies"])
    w.writerows(rows)

print("Wrote", out)
