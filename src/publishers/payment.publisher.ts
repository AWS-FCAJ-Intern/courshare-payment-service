import { SendMessageCommand } from "@aws-sdk/client-sqs";
import { sqsClient } from "../config/sqs";
import { PaymentEvent } from "../events/payment.event";

export class PaymentPublisher {
  private readonly queueUrl = (() => {
    const url = process.env.PAYMENT_EVENTS_QUEUE_URL;
    if (!url) throw new Error('PAYMENT_EVENTS_QUEUE_URL is not defined');
    return url;
  })();

  async publish(event: PaymentEvent): Promise<void> {
    const command = new SendMessageCommand({
      QueueUrl: this.queueUrl,
      MessageBody: JSON.stringify(event),
    });
    await sqsClient.send(command);
  }
}

export const paymentPublisher = new PaymentPublisher();