import { expect, jest, test, describe, beforeEach } from "@jest/globals";
import { Request, Response } from "express";
import {
  getReminders,
  createReminder,
  patchReminder,
  deleteReminder,
  checkReminderTriggers,
} from "../../controllers/reminders";
import * as reminderService from "../../services/reminder-service";
import * as reminderUtil from "../../utils/reminders";
import { IReminder } from "../../interfaces/reminder-interface";
import { TriggerType } from "../../interfaces/trigger-interface";
import config from "../../config/config";

// Mock the reminder service and utilities
jest.mock("../../services/reminder-service");
jest.mock("../../utils/reminders");
const mockedReminderService = reminderService as jest.Mocked<
  typeof reminderService
>;
const mockedReminderUtil = reminderUtil as jest.Mocked<typeof reminderUtil>;

describe("Reminders Controller", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let responseJson: jest.Mock;
  let responseStatus: jest.Mock;
  let responseSend: jest.Mock;

  beforeEach(() => {
    responseJson = jest.fn().mockReturnThis();
    responseStatus = jest
      .fn()
      .mockReturnValue({ json: responseJson, send: jest.fn() });
    responseSend = jest.fn().mockReturnThis();

    // Setup mock request and response
    mockRequest = {
      user: { id: "user-123" },
      body: {},
      params: {},
    };

    mockResponse = {
      json: responseJson as any,
      status: responseStatus as any,
      send: responseSend as any,
    };

    // Reset mocks before each test
    jest.clearAllMocks();
  });

  describe("getReminders", () => {
    test("should return reminders when found", async () => {
      const mockReminders: IReminder[] = [
        {
          id: "reminder-1",
          user_id: "user-123",
          description: "Test reminder",
          enabled: true,
          created_at: "2023-01-01T00:00:00Z",
          trigger: TriggerType.WEATHER,
          metadata: {},
        },
      ];

      mockedReminderService.getRemindersForUser.mockResolvedValue({
        data: mockReminders,
        error: null,
      });

      await getReminders(mockRequest as Request, mockResponse as Response);

      expect(mockedReminderService.getRemindersForUser).toHaveBeenCalledWith(
        "user-123"
      );
      expect(responseStatus).toHaveBeenCalledWith(200);
      expect(responseJson).toHaveBeenCalledWith(mockReminders);
    });

    test("should return empty array when no reminders found", async () => {
      mockedReminderService.getRemindersForUser.mockResolvedValue({
        data: null,
        error: null,
      });

      await getReminders(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(200);
      expect(responseJson).toHaveBeenCalledWith([]);
    });

    test("should handle errors", async () => {
      const mockError = Object.assign(new Error("Database error"), {
        details: "Connection failed",
        hint: "Check connection",
        code: "DB_ERROR",
      });

      mockedReminderService.getRemindersForUser.mockResolvedValue({
        data: null,
        error: mockError,
      });

      await getReminders(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(500);
      expect(responseJson).toHaveBeenCalledWith({
        error: "Error getting reminders",
        status: 500,
      });
    });
  });

  describe("createReminder", () => {
    test("should create a reminder successfully", async () => {
      const reminderData: Partial<IReminder> = {
        description: "New reminder",
        enabled: true,
        trigger: TriggerType.WEATHER,
        metadata: {},
      };

      mockRequest.body = reminderData;

      const createdReminder: IReminder = {
        ...(reminderData as IReminder),
        id: "new-reminder-id",
        user_id: "user-123",
        created_at: "2023-01-01T00:00:00Z",
      };

      mockedReminderService.createNewReminder.mockResolvedValue({
        data: createdReminder,
        error: null,
      });

      await createReminder(mockRequest as Request, mockResponse as Response);

      expect(mockedReminderService.createNewReminder).toHaveBeenCalledWith(
        reminderData,
        "user-123"
      );
      expect(responseJson).toHaveBeenCalledWith({
        message: "Reminder created successfully",
        reminder: createdReminder,
      });
    });

    test("should handle creation errors", async () => {
      const reminderData: Partial<IReminder> = {
        description: "New reminder",
        enabled: true,
        trigger: TriggerType.TFL,
        metadata: {}, // Missing required 'line' for TFL
      };

      mockRequest.body = reminderData;

      const mockError = new Error("Invalid metadata for TFL trigger");

      mockedReminderService.createNewReminder.mockResolvedValue({
        data: null as any,
        error: mockError,
      });

      await createReminder(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(400);
      expect(responseJson).toHaveBeenCalledWith({ error: mockError.message });
    });
  });

  describe("patchReminder", () => {
    beforeEach(() => {
      mockRequest.params = { id: "reminder-1" };
    });

    test("should update a reminder successfully", async () => {
      const updateData: Partial<IReminder> = {
        description: "Updated reminder",
        enabled: false,
      };

      mockRequest.body = updateData;

      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [
          {
            id: "reminder-1",
            user_id: "user-123",
            description: "Original reminder",
            enabled: true,
            created_at: "2023-01-01T00:00:00Z",
          },
        ],
        error: null,
      });

      const updatedReminder = [
        {
          id: "reminder-1",
          user_id: "user-123",
          description: "Updated reminder",
          enabled: false,
          created_at: "2023-01-01T00:00:00Z",
        },
      ];

      mockedReminderService.patchReminderById.mockResolvedValue({
        data: updatedReminder,
        error: null,
      });

      await patchReminder(mockRequest as Request, mockResponse as Response);

      expect(mockedReminderService.getRemindersById).toHaveBeenCalledWith(
        "reminder-1",
        "user-123"
      );
      expect(mockedReminderService.patchReminderById).toHaveBeenCalledWith(
        "reminder-1",
        "user-123",
        updateData
      );
      expect(responseJson).toHaveBeenCalledWith({
        message: "Reminder updated successfully",
        reminder: updatedReminder,
      });
    });

    test("should return 404 when reminder not found", async () => {
      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [],
        error: null,
      });

      await patchReminder(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(404);
      expect(responseJson).toHaveBeenCalledWith({
        error: "Reminder with id=reminder-1 not found",
      });
      expect(mockedReminderService.patchReminderById).not.toHaveBeenCalled();
    });

    test("should handle update errors", async () => {
      const updateData: Partial<IReminder> = {
        description: "Updated reminder",
      };

      mockRequest.body = updateData;

      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [
          {
            id: "reminder-1",
            user_id: "user-123",
            description: "Original reminder",
            enabled: true,
            created_at: "2023-01-01T00:00:00Z",
          },
        ],
        error: null,
      });

      const mockError = Object.assign(new Error("Update failed"), {
        details: "Invalid data",
        hint: "Check data format",
        code: "DB_ERROR",
      });

      mockedReminderService.patchReminderById.mockResolvedValue({
        data: null as any,
        error: mockError,
      });

      await patchReminder(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(400);
      expect(responseJson).toHaveBeenCalledWith({ error: mockError.message });
    });
  });

  describe("deleteReminder", () => {
    beforeEach(() => {
      mockRequest.params = { id: "reminder-1" };
    });

    test("should delete a reminder successfully", async () => {
      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [
          {
            id: "reminder-1",
            user_id: "user-123",
            description: "Test reminder",
            enabled: true,
            created_at: "2023-01-01T00:00:00Z",
          },
        ],
        error: null,
      });

      mockedReminderService.deleteReminderById.mockResolvedValue({
        error: null,
      });

      await deleteReminder(mockRequest as Request, mockResponse as Response);

      expect(mockedReminderService.getRemindersById).toHaveBeenCalledWith(
        "reminder-1",
        "user-123"
      );
      expect(mockedReminderService.deleteReminderById).toHaveBeenCalledWith(
        "reminder-1",
        "user-123"
      );
      expect(responseSend).toHaveBeenCalledWith({
        message: "Reminder deleted successfully",
        reminderId: "reminder-1",
      });
    });

    test("should return 404 when reminder not found", async () => {
      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [],
        error: null,
      });

      await deleteReminder(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(404);
      expect(responseJson).toHaveBeenCalledWith({
        error: "Reminder with id=reminder-1 not found",
      });
      expect(mockedReminderService.deleteReminderById).not.toHaveBeenCalled();
    });

    test("should handle delete errors", async () => {
      // Mock the getRemindersById to return a reminder
      mockedReminderService.getRemindersById.mockResolvedValue({
        data: [
          {
            id: "reminder-1",
            user_id: "user-123",
            description: "Test reminder",
            enabled: true,
            created_at: "2023-01-01T00:00:00Z",
          },
        ],
        error: null,
      });

      const mockError = Object.assign(new Error("Delete failed"), {
        details: "Database error",
        hint: "Check connection",
        code: "DB_ERROR",
      });

      mockedReminderService.deleteReminderById.mockResolvedValue({
        error: mockError,
      });

      await deleteReminder(mockRequest as Request, mockResponse as Response);

      expect(responseStatus).toHaveBeenCalledWith(500);
      expect(responseJson).toHaveBeenCalledWith({ error: mockError.message });
    });
  });
});

// Testing the checkReminderTriggers function separately as it has rate-limiting that can interfere with tests
describe("Reminder Trigger Controller", () => {
  let mockRequest: Partial<Request>;
  let mockResponse: Partial<Response>;
  let responseJson: jest.Mock;
  let responseStatus: jest.Mock;

  beforeEach(() => {
    responseJson = jest.fn().mockReturnThis();
    responseStatus = jest
      .fn()
      .mockReturnValue({ json: responseJson, send: jest.fn() });

    mockRequest = {
      user: { id: "trigger-test-user" },
      body: {},
      params: {},
    };

    mockResponse = {
      json: responseJson as any,
      status: responseStatus as any,
      send: jest.fn() as any,
    };

    jest.clearAllMocks();
  });

  test("should require location in request", async () => {
    mockRequest.body = {};

    await checkReminderTriggers(
      mockRequest as Request,
      mockResponse as Response
    );

    expect(responseStatus).toHaveBeenCalledWith(400);
    expect(responseJson).toHaveBeenCalledWith({
      error: "Location is required",
    });
    expect(mockedReminderService.getRemindersForUser).not.toHaveBeenCalled();
  });

  test("should check triggers and return matching reminders", async () => {
    const location = { lat: 51.5074, lng: -0.1278 };
    mockRequest.body = { location };

    const mockReminders: IReminder[] = [
      {
        id: "reminder-1",
        user_id: "trigger-test-user",
        description: "Test reminder",
        enabled: true,
        created_at: "2023-01-01T00:00:00Z",
        trigger: TriggerType.WEATHER,
      },
    ];

    const triggeredReminders = [
      {
        reminder: mockReminders[0],
        message: "Test message",
      },
    ];

    mockedReminderService.getRemindersForUser.mockResolvedValue({
      data: mockReminders,
      error: null,
    });

    mockedReminderUtil.getRemindersToTrigger.mockResolvedValue(
      triggeredReminders
    );

    await checkReminderTriggers(
      mockRequest as Request,
      mockResponse as Response
    );

    expect(mockedReminderService.getRemindersForUser).toHaveBeenCalledWith(
      "trigger-test-user"
    );
    expect(mockedReminderUtil.getRemindersToTrigger).toHaveBeenCalledWith(
      mockReminders,
      location
    );
    expect(responseJson).toHaveBeenCalledWith({
      reminders: triggeredReminders,
    });
  });

  test("should handle database errors", async () => {
    const location = { lat: 51.5074, lng: -0.1278 };
    mockRequest.body = { location };
    mockRequest.user = { id: "error-test-user" };

    const mockError = Object.assign(new Error("Database error"), {
      details: "Connection failed",
      hint: "Check connection",
      code: "DB_ERROR",
    });

    mockedReminderService.getRemindersForUser.mockResolvedValue({
      data: null,
      error: mockError,
    });

    await checkReminderTriggers(
      mockRequest as Request,
      mockResponse as Response
    );

    expect(responseStatus).toHaveBeenCalledWith(500);
    expect(responseJson).toHaveBeenCalledWith({
      error: "Error getting reminders",
    });
    expect(mockedReminderUtil.getRemindersToTrigger).not.toHaveBeenCalled();
  });
});
