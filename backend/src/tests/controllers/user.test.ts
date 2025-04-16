import { expect, jest, test, describe, beforeEach } from "@jest/globals";
import { Request, Response } from "express";
import { getUser, patchUser } from "../../controllers/user";
import * as userService from "../../services/user-service";
import { IUser } from "../../interfaces/user-interface";

// Mock the user service
jest.mock("../../services/user-service");
const mockedUserService = userService as jest.Mocked<typeof userService>;

describe("User Controller", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let responseJson: jest.Mock;
  let responseStatus: jest.Mock;

  beforeEach(() => {
    responseJson = jest.fn().mockReturnThis();
    responseStatus = jest.fn().mockReturnThis();

    // Setup mock request and response
    mockRequest = {
      user: { id: "user-123" },
      body: {}
    };

    mockResponse = {
      json: responseJson as any,
      status: responseStatus as any,
      send: jest.fn() as any
    };
  });

  describe("getUser", () => {
    test("should return user data on successful fetch", async () => {
      const mockUser: IUser = { 
        id: "user-123", 
        email: "test@example.com",
        created_at: new Date(),
        radius: 500, 
        fetch_interval: 60000,
        battery_saver_mode: false,
        blacklist: new Map()
      };

      mockedUserService.getUserById.mockResolvedValue({
        data: mockUser,
        error: null
      });

      await getUser(mockRequest as Request, mockResponse as Response);

      expect(mockedUserService.getUserById).toHaveBeenCalledWith("user-123");
      expect(responseJson).toHaveBeenCalledWith(mockUser);
      expect(responseStatus).not.toHaveBeenCalled();
    });

    test("should return error when getUserById fails", async () => {
      const mockError = {
        message: "Database error",
        details: "Connection failed",
        hint: "Check connection",
        code: "DB_ERROR",
        name: "PostgrestError"
      };

      mockedUserService.getUserById.mockResolvedValue({
        data: null as any,
        error: mockError
      });

      await getUser(mockRequest as Request, mockResponse as Response);

      expect(mockedUserService.getUserById).toHaveBeenCalledWith("user-123");
      expect(responseStatus).toHaveBeenCalledWith(400);
      expect(responseJson).toHaveBeenCalledWith({
        error: mockError.message
      });
    });
  });

  describe("patchUser", () => {
    test("should update user successfully", async () => {
      const updateData = {
        radius: 1000,
        fetch_interval: 120000,
        battery_saver_mode: true
      };

      mockRequest.body = updateData;

      const updatedUser: IUser = {
        id: "user-123",
        email: "test@example.com",
        created_at: new Date(),
        radius: 1000,
        fetch_interval: 120000,
        battery_saver_mode: true,
        blacklist: new Map()
      };

      mockedUserService.patchUserById.mockResolvedValue({
        data: updatedUser,
        error: null
      });

      await patchUser(mockRequest as Request, mockResponse as Response);

      expect(mockedUserService.patchUserById).toHaveBeenCalledWith("user-123", updateData);
      expect(responseJson).toHaveBeenCalledWith(updatedUser);
      expect(responseStatus).not.toHaveBeenCalled();
    });

    test("should return error when patchUserById fails", async () => {
      const updateData = {
        radius: 1000,
        fetch_interval: 120000,
        battery_saver_mode: true
      };

      mockRequest.body = updateData;
      const mockError = {
        message: "Update failed",
        details: "Invalid data",
        hint: "Check data format",
        code: "DB_ERROR",
        name: "PostgrestError"
      };

      mockedUserService.patchUserById.mockResolvedValue({
        data: null as any,
        error: mockError
      });

      await patchUser(mockRequest as Request, mockResponse as Response);

      expect(mockedUserService.patchUserById).toHaveBeenCalledWith("user-123", updateData);
      expect(responseStatus).toHaveBeenCalledWith(400);
      expect(responseJson).toHaveBeenCalledWith({
        error: mockError.message
      });
    });
  });
});