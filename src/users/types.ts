import type { ObjectId } from "mongodb";

type VerificationStatus = "pending" | "verified" | "rejected";

type PermissionOverrides = { include?: string[]; exclude?: string[] };

type Role = {
  id: ObjectId;
  display: string;
  modifyPermissions?: PermissionOverrides;
};

export interface User {
  name: string;
  surnames: string;
  email: string;
  universityId: string;
  passwordHash: string;
  verificationStatus: VerificationStatus;
  role: Role;
  createdAt: Date;
};

